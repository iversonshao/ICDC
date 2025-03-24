module Bicubic (
input CLK,
input RST,
input [6:0] V0,
input [6:0] H0,
input [4:0] SW,
input [4:0] SH,
input [5:0] TW,
input [5:0] TH,
output reg DONE);

wire [7:0] img_data;
wire [7:0] res_data;
reg [13:0] img_addr;
reg [13:0] result_addr;
reg img_cen;
reg res_cen;
reg res_wen;
ImgROM u_ImgROM (.Q(img_data), .CLK(CLK), .CEN(img_cen), .A(img_addr));
ResultSRAM u_ResultSRAM (.Q(), .CLK(CLK), .CEN(res_cen), .WEN(res_wen), .A(result_addr), .D(cubic_result));

reg [2:0] state, next_state;
parameter IDLE = 3'd0,
          READ = 3'd1,
          COMPUTE = 3'd2,
          WRITE = 3'd3,
          FINISH = 3'd4;

reg [6:0] v0_reg, h0_reg;
reg [4:0] sw_reg, sh_reg;
reg [5:0] tw_reg, th_reg;

reg [5:0] target_x, target_y;
reg [7:0] cubic_result;

reg [4:0] read_counter;
reg [7:0] pixel_buffer [0:15];
reg [13:0] real_x, real_y;
reg [6:0] base_x, base_y;

reg signed [31:0] dx, dy;
reg signed [31:0] a0, a1, a2, a3; // Coef for vertical interpolation
reg signed [31:0] b0, b1, b2, b3; // Coef for horizontal interpolation
reg signed [31:0] p0, p1, p2, p3; // Coef for vertical differentiation
reg signed [31:0] result;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        IDLE: next_state = READ;
        READ: begin
            if (read_counter == 5'd19) begin
                next_state = COMPUTE;
            end else begin
                next_state = READ;
            end
        end
        COMPUTE: next_state = WRITE;
        WRITE: begin
            if (target_x == tw_reg-1 && target_y == th_reg-1) begin
                next_state = FINISH;
            end else begin
                next_state = COMPUTE;
            end
        end
        FINISH:
            next_state = IDLE;
        default:
            next_state = IDLE;
    endcase
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        DONE <= 1'b0;
        img_cen <= 1'b1;
        res_cen <= 1'b1;
        res_wen <= 1'b1;
        target_x <= 6'd0;
        target_y <= 6'd0;
        read_counter <= 5'd0;
        img_addr <= 14'd0;
    end else begin
        case(state)
            IDLE: begin
                DONE <= 1'b0;
                v0_reg <= V0;
                h0_reg <= H0;
                sw_reg <= SW;
                sh_reg <= SH;
                tw_reg <= TW;
                th_reg <= TH;

                target_x <= 6'd0;
                target_y <= 6'd0;
                read_counter <= 5'd0;

                img_cen <= 1'b1;
                res_cen <= 1'b1;
                res_wen <= 1'b1;
            end
            READ: begin
                img_cen <= 1'b0;
                if (read_counter == 5'd0) begin
                    real_x <= (h0_reg << 8) + (target_x * ((sw_reg << 8) / tw_reg));
                    real_y <= (v0_reg << 8) + (target_y * ((sh_reg << 8) / th_reg));
                    read_counter <= 5'd1;
                end else if (read_counter == 5'd1) begin
                    base_x <= real_x >> 8;
                    base_y <= real_y >> 8;
                    read_counter <= 5'd2;
                end else if (read_counter == 5'd2) begin
                    img_addr <= (base_y - 1) * 100 + (base_x - 1);
                    read_counter <= 5'd3;
                end else if (read_counter >= 5'd3 && read_counter < 5'd19)begin
                    if (read_counter == 5'd3) begin
                        pixel_buffer[read_counter-4] <= img_data;
                    end else begin
                        case (read_counter)
                            5'd3: img_addr <= (base_y - 1) * 100 + base_x;
                            5'd4: img_addr <= (base_y - 1) * 100 + (base_x + 1);
                            5'd5: img_addr <= (base_y - 1) * 100 + (base_x + 2);
                            5'd6: img_addr <= base_y * 100 + (base_x - 1);
                            5'd7: img_addr <= base_y * 100 + base_x;
                            5'd8: img_addr <= base_y * 100 + (base_x + 1);
                            5'd9: img_addr <= base_y * 100 + (base_x + 2);
                            5'd10: img_addr <= (base_y + 1) * 100 + (base_x - 1);
                            5'd11: img_addr <= (base_y + 1) * 100 + base_x;
                            5'd12: img_addr <= (base_y + 1) * 100 + (base_x + 1);
                            5'd13: img_addr <= (base_y + 1) * 100 + (base_x + 2);
                            5'd14: img_addr <= (base_y + 2) * 100 + (base_x - 1);
                            5'd15: img_addr <= (base_y + 2) * 100 + base_x;
                            5'd16: img_addr <= (base_y + 2) * 100 + (base_x + 1);
                            5'd17: img_addr <= (base_y + 2) * 100 + (base_x + 2);
                            5'd18: img_addr <= img_addr;
                        endcase
                    end
                    read_counter <= read_counter + 5'd1;
                end else begin
                    pixel_buffer[15] <= img_data;
                    read_counter <= 5'd0;
                    img_cen <= 1'b1;
                end

            end
            COMPUTE: begin
                img_cen <= 1'b1;
                res_cen <= 1'b1;
                res_wen <= 1'b1;

                dx <= real_x[7:0];
                dy <= real_y[7:0];

                a0 <= (-dx * (dx - 8'd256) * (dx - 8'd512)) >> 9; //-dx(dx-1)(dx-2)/6
                a1 <= ((dx + 8'd256) * (8'd256 - dx) * (dx - 8'd512)) >> 8; //(dx+1)(dx-2)(1-dx)/2
                a2 <= ((dx + 8'd256) * dx * (8'd512 - dx)) >> 8; // (dx+1)dx(2-dx)/2
                a3 <= (dx * (dx - 8'd256) * dx) >> 9; //dx(dx-1)(dx)/6

                p0 <= ((a0 * $signed({1'b0, pixel_buffer[0]}) + 
                      a1 * $signed({1'b0, pixel_buffer[1]}) + 
                      a2 * $signed({1'b0, pixel_buffer[2]}) + 
                      a3 * $signed({1'b0, pixel_buffer[3]})) >> 8);
                
                p1 <= ((a0 * $signed({1'b0, pixel_buffer[4]}) +
                      a1 * $signed({1'b0, pixel_buffer[5]}) +
                      a2 * $signed({1'b0, pixel_buffer[6]}) +
                      a3 * $signed({1'b0, pixel_buffer[7]})) >> 8);

                p2 <= ((a0 * $signed({1'b0, pixel_buffer[8]}) +
                        a1 * $signed({1'b0, pixel_buffer[9]}) +
                        a2 * $signed({1'b0, pixel_buffer[10]}) +
                        a3 * $signed({1'b0, pixel_buffer[11]})) >> 8);

                p3 <= ((a0 * $signed({1'b0, pixel_buffer[12]}) +
                        a1 * $signed({1'b0, pixel_buffer[13]}) +
                        a2 * $signed({1'b0, pixel_buffer[14]}) +
                        a3 * $signed({1'b0, pixel_buffer[15]})) >> 8);
                b0 <= (-dy * (dy - 8'd256) * (dy - 8'd512)) >> 9;
                b1 <= ((dy + 8'd256) * (8'd256 - dy) * (dy - 8'd512)) >> 8;
                b2 <= ((dy + 8'd256) * dy * (8'd512 - dy)) >> 8;
                b3 <= (dy * (dy - 8'd256) * dy) >> 9;

                result <= ((b0 * p0 + b1 * p1 + b2 * p2 + b3 * p3) >> 8);

                if (result < 8'd0) begin
                    cubic_result <= 8'd0;
                end else if (result > 8'd255) begin
                    cubic_result <= 8'd255;
                end else begin
                    cubic_result <= result[7:0] + ((result[7:0] & 8'h80) ? 8'd1 : 8'd0);
                end
            end
            WRITE: begin
                res_cen <= 1'b0;
                res_wen <= 1'b0;
                result_addr <= target_y * tw_reg + target_x;

                if (target_x < tw_reg - 1) begin
                    target_x <= target_x + 6'd1;
                end else begin
                    target_x <= 6'd0;
                    target_y <= target_y + 6'd1;
                end
            end
            FINISH: begin
                DONE <= 1'b1;
                img_cen <= 1'b1;
                res_cen <= 1'b1;
                res_wen <= 1'b1;
            end
            default: begin
                img_cen <= 1'b1;
                res_cen <= 1'b1;
                res_wen <= 1'b1;
            end
        endcase
    end
end



endmodule