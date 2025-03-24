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
        READ: next_state = COMPUTE;
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

                img_cen <= 1'b1;
                res_cen <= 1'b1;
                res_wen <= 1'b1;
            end
            READ: begin
                img_cen <= 1'b0;
            end
            COMPUTE: begin
                img_cen <= 1'b1;
                res_cen <= 1'b1;
                res_wen <= 1'b1;
            end
            WRITE: begin
                res_cen <= 1'b0;
                res_wen <= 1'b0;
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