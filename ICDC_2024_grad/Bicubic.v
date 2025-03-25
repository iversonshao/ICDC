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

// ROM and SRAM interface signals
wire [7:0] rom_data;
reg [13:0] rom_addr;
reg rom_cen;
reg [13:0] sram_addr;
reg sram_cen;
reg sram_wen;
reg [7:0] sram_data;

// Instantiate ROM and SRAM
ImgROM u_ImgROM (.Q(rom_data), .CLK(CLK), .CEN(rom_cen), .A(rom_addr));
ResultSRAM u_ResultSRAM (.Q(), .CLK(CLK), .CEN(sram_cen), .WEN(sram_wen), .A(sram_addr), .D(sram_data));

// State machine definition
reg [3:0] state, next_state;
parameter IDLE = 4'd0,
          INIT = 4'd1,
          READ_PIXELS = 4'd2,
          CALC_H1 = 4'd3,
          CALC_H2 = 4'd4,
          CALC_H3 = 4'd5,
          CALC_H4 = 4'd6,
          CALC_V = 4'd7,
          WRITE = 4'd8,
          NEXT_PIXEL = 4'd9,
          DONE_STATE = 4'd10;

// Parameter storage
reg [6:0] v0_reg, h0_reg;
reg [4:0] sw_reg, sh_reg;
reg [5:0] tw_reg, th_reg;
reg [5:0] tx, ty;          // Target pixel coordinates
reg [4:0] read_cnt;        // Read counter

// Fixed-point calculations (16.8 format)
reg [23:0] pos_x, pos_y;   // Position in source image (24 bits for calculation)
reg [23:0] dx_acc, dy_acc; // Step accumulators

// Pixel and interpolation result storage
reg [7:0] pixels[0:15];    // 16 pixels
reg signed [15:0] h_interp[0:3]; // Horizontal interpolation results
reg signed [15:0] v_result;      // Vertical interpolation result

// Interpolation calculation variables
reg [7:0] dx, dy;          // Fractional parts
reg [6:0] ix, iy;          // Integer parts
reg signed [15:0] a0, a1, a2, a3; // Interpolation coefficients
reg signed [15:0] interp_tmp;     // Temporary storage for interpolation calculation

// Address calculation variables
wire [13:0] base_addr;
// Use shifts and additions to calculate base address (iy * 100 = iy * 64 + iy * 32 + iy * 4)
assign base_addr = {iy, 6'b0} + {iy, 5'b0} + {iy, 2'b0};

// State machine transition logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case(state)
        IDLE:        next_state = INIT;
        INIT:        next_state = READ_PIXELS;
        READ_PIXELS: next_state = (read_cnt == 5'd16) ? CALC_H1 : READ_PIXELS;
        CALC_H1:     next_state = CALC_H2;
        CALC_H2:     next_state = CALC_H3;
        CALC_H3:     next_state = CALC_H4;
        CALC_H4:     next_state = CALC_V;
        CALC_V:      next_state = WRITE;
        WRITE:       next_state = NEXT_PIXEL;
        NEXT_PIXEL:  next_state = (tx == tw_reg-1 && ty == th_reg-1) ? DONE_STATE : READ_PIXELS;
        DONE_STATE:  next_state = IDLE;
        default:     next_state = IDLE;
    endcase
end

// Main processing logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        DONE <= 1'b0;
        rom_cen <= 1'b1;
        sram_cen <= 1'b1;
        sram_wen <= 1'b1;
        tx <= 0;
        ty <= 0;
        read_cnt <= 0;
    end else begin
        case (state)
            IDLE: begin
                // Initialize signals
                DONE <= 1'b0;
                rom_cen <= 1'b1;
                sram_cen <= 1'b1;
                sram_wen <= 1'b1;
            end

            INIT: begin
                // Store input parameters
                v0_reg <= V0;
                h0_reg <= H0;
                sw_reg <= SW;
                sh_reg <= SH;
                tw_reg <= TW;
                th_reg <= TH;
                
                // Initialize target coordinates
                tx <= 0;
                ty <= 0;
                
                // Calculate x and y direction steps (fixed-point format)
                // Step = (source_size << 8) / target_size
                
                // Optimize for TW that is a power of 2
                if (tw_reg == 6'd8)
                    dx_acc <= {sw_reg, 8'b0} >> 3;
                else if (tw_reg == 6'd16)
                    dx_acc <= {sw_reg, 8'b0} >> 4;
                else if (tw_reg == 6'd32)
                    dx_acc <= {sw_reg, 8'b0} >> 5;
                else begin
                    // For non-power-of-2, use a more general method (approximation)
                    // Calculate (sw << 8) / tw
                    // Expand numerator, then approximate division with shift
                    dx_acc <= ({sw_reg, 8'b0} >> 5) * (6'd32 / tw_reg);
                end
                
                // Optimize for TH that is a power of 2
                if (th_reg == 6'd8)
                    dy_acc <= {sh_reg, 8'b0} >> 3;
                else if (th_reg == 6'd16)
                    dy_acc <= {sh_reg, 8'b0} >> 4;
                else if (th_reg == 6'd32)
                    dy_acc <= {sh_reg, 8'b0} >> 5;
                else begin
                    // For non-power-of-2, use a more general method (approximation)
                    dy_acc <= ({sh_reg, 8'b0} >> 5) * (6'd32 / th_reg);
                end
                
                // Set initial position
                pos_x <= {h0_reg, 8'b0};
                pos_y <= {v0_reg, 8'b0};
            end

            READ_PIXELS: begin
                if (read_cnt == 0) begin
                    // Calculate integer and fractional parts
                    ix <= pos_x >> 8;
                    iy <= (pos_y >> 8) & 7'b1111111;
                    dx <= pos_x[7:0];
                    dy <= pos_y[7:0];
                    read_cnt <= read_cnt + 1;
                    rom_cen <= 1'b0; // Enable ROM reading
                end
                else if (read_cnt <= 16) begin
                    // Read 16 pixels
                    case (read_cnt)
                        5'd1: rom_addr <= base_addr - 100 + (ix - 1); // (iy-1)*100 + (ix-1)
                        5'd2: begin 
                                rom_addr <= base_addr - 100 + ix;      // (iy-1)*100 + ix
                                pixels[0] <= rom_data;                // Store previous pixel
                              end
                        5'd3: begin
                                rom_addr <= base_addr - 100 + (ix + 1); // (iy-1)*100 + (ix+1)
                                pixels[1] <= rom_data;
                              end
                        5'd4: begin
                                rom_addr <= base_addr - 100 + (ix + 2); // (iy-1)*100 + (ix+2)
                                pixels[2] <= rom_data;
                              end
                        5'd5: begin
                                rom_addr <= base_addr + (ix - 1);      // iy*100 + (ix-1)
                                pixels[3] <= rom_data;
                              end
                        5'd6: begin
                                rom_addr <= base_addr + ix;            // iy*100 + ix
                                pixels[4] <= rom_data;
                              end
                        5'd7: begin
                                rom_addr <= base_addr + (ix + 1);      // iy*100 + (ix+1)
                                pixels[5] <= rom_data;
                              end
                        5'd8: begin
                                rom_addr <= base_addr + (ix + 2);      // iy*100 + (ix+2)
                                pixels[6] <= rom_data;
                              end
                        5'd9: begin
                                rom_addr <= base_addr + 100 + (ix - 1); // (iy+1)*100 + (ix-1)
                                pixels[7] <= rom_data;
                              end
                        5'd10: begin
                                rom_addr <= base_addr + 100 + ix;       // (iy+1)*100 + ix
                                pixels[8] <= rom_data;
                               end
                        5'd11: begin
                                rom_addr <= base_addr + 100 + (ix + 1); // (iy+1)*100 + (ix+1)
                                pixels[9] <= rom_data;
                               end
                        5'd12: begin
                                rom_addr <= base_addr + 100 + (ix + 2); // (iy+1)*100 + (ix+2)
                                pixels[10] <= rom_data;
                               end
                        5'd13: begin
                                rom_addr <= base_addr + 200 + (ix - 1); // (iy+2)*100 + (ix-1)
                                pixels[11] <= rom_data;
                               end
                        5'd14: begin
                                rom_addr <= base_addr + 200 + ix;       // (iy+2)*100 + ix
                                pixels[12] <= rom_data;
                               end
                        5'd15: begin
                                rom_addr <= base_addr + 200 + (ix + 1); // (iy+2)*100 + (ix+1)
                                pixels[13] <= rom_data;
                               end
                        5'd16: begin
                                rom_addr <= base_addr + 200 + (ix + 2); // (iy+2)*100 + (ix+2)
                                pixels[14] <= rom_data;
                               end
                    endcase
                    read_cnt <= read_cnt + 1;
                end
                else begin
                    pixels[15] <= rom_data; // Save the last pixel
                    rom_cen <= 1'b1;        // Disable ROM reading
                    read_cnt <= 0;
                end
            end

            CALC_H1: begin
                // Calculate bicubic interpolation coefficients
                // a0 = -x(x-1)(x-2)/6 ... approximate calculation
                a0 <= -((dx * ((dx << 2) - dx - (dx << 1)) >> 3) >> 3);
                
                // a1 = (x+1)(1-x)(x-2)/2 ... approximate calculation
                a1 <= ((dx + 8'd1) * (8'd1 - dx) * (dx - 8'd2)) >> 3;
                
                // a2 = (x+1)x(2-x)/2 ... approximate calculation
                a2 <= ((dx + 8'd1) * dx * (8'd2 - dx)) >> 3;
                
                // a3 = x(x-1)x/6 ... approximate calculation
                a3 <= ((dx * (dx - 8'd1) * dx) >> 3) >> 3;
                
                // First row horizontal interpolation
                interp_tmp = (a0 * $signed({1'b0, pixels[0]})) >> 6;
                interp_tmp = interp_tmp + ((a1 * $signed({1'b0, pixels[1]})) >> 6);
                interp_tmp = interp_tmp + ((a2 * $signed({1'b0, pixels[2]})) >> 6);
                interp_tmp = interp_tmp + ((a3 * $signed({1'b0, pixels[3]})) >> 6);
                
                // Clamp range and round
                if (interp_tmp < 0)
                    h_interp[0] <= 0;
                else if (interp_tmp > 255)
                    h_interp[0] <= 255;
                else
                    h_interp[0] <= interp_tmp[7:0] + ((interp_tmp[7:0] & 8'h80) ? 8'd1 : 8'd0);
            end

            CALC_H2: begin
                // Second row horizontal interpolation
                interp_tmp = (a0 * $signed({1'b0, pixels[4]})) >> 6;
                interp_tmp = interp_tmp + ((a1 * $signed({1'b0, pixels[5]})) >> 6);
                interp_tmp = interp_tmp + ((a2 * $signed({1'b0, pixels[6]})) >> 6);
                interp_tmp = interp_tmp + ((a3 * $signed({1'b0, pixels[7]})) >> 6);
                
                // Clamp range and round
                if (interp_tmp < 0)
                    h_interp[1] <= 0;
                else if (interp_tmp > 255)
                    h_interp[1] <= 255;
                else
                    h_interp[1] <= interp_tmp[7:0] + ((interp_tmp[7:0] & 8'h80) ? 8'd1 : 8'd0);
            end

            CALC_H3: begin
                // Third row horizontal interpolation
                interp_tmp = (a0 * $signed({1'b0, pixels[8]})) >> 6;
                interp_tmp = interp_tmp + ((a1 * $signed({1'b0, pixels[9]})) >> 6);
                interp_tmp = interp_tmp + ((a2 * $signed({1'b0, pixels[10]})) >> 6);
                interp_tmp = interp_tmp + ((a3 * $signed({1'b0, pixels[11]})) >> 6);
                
                // Clamp range and round
                if (interp_tmp < 0)
                    h_interp[2] <= 0;
                else if (interp_tmp > 255)
                    h_interp[2] <= 255;
                else
                    h_interp[2] <= interp_tmp[7:0] + ((interp_tmp[7:0] & 8'h80) ? 8'd1 : 8'd0);
            end

            CALC_H4: begin
                // Fourth row horizontal interpolation
                interp_tmp = (a0 * $signed({1'b0, pixels[12]})) >> 6;
                interp_tmp = interp_tmp + ((a1 * $signed({1'b0, pixels[13]})) >> 6);
                interp_tmp = interp_tmp + ((a2 * $signed({1'b0, pixels[14]})) >> 6);
                interp_tmp = interp_tmp + ((a3 * $signed({1'b0, pixels[15]})) >> 6);
                
                // Clamp range and round
                if (interp_tmp < 0)
                    h_interp[3] <= 0;
                else if (interp_tmp > 255)
                    h_interp[3] <= 255;
                else
                    h_interp[3] <= interp_tmp[7:0] + ((interp_tmp[7:0] & 8'h80) ? 8'd1 : 8'd0);
                
                // Update bicubic coefficients (using dy instead of dx for vertical direction)
                // b0 = -y(y-1)(y-2)/6 ... approximate calculation
                a0 <= -((dy * ((dy << 2) - dy - (dy << 1)) >> 3) >> 3);
                
                // b1 = (y+1)(1-y)(y-2)/2 ... approximate calculation
                a1 <= ((dy + 8'd1) * (8'd1 - dy) * (dy - 8'd2)) >> 3;
                
                // b2 = (y+1)y(2-y)/2 ... approximate calculation
                a2 <= ((dy + 8'd1) * dy * (8'd2 - dy)) >> 3;
                
                // b3 = y(y-1)y/6 ... approximate calculation
                a3 <= ((dy * (dy - 8'd1) * dy) >> 3) >> 3;
            end

            CALC_V: begin
                // Vertical interpolation calculation
                interp_tmp = (a0 * h_interp[0]) >> 6;
                interp_tmp = interp_tmp + ((a1 * h_interp[1]) >> 6);
                interp_tmp = interp_tmp + ((a2 * h_interp[2]) >> 6);
                interp_tmp = interp_tmp + ((a3 * h_interp[3]) >> 6);
                
                // Clamp range and round
                if (interp_tmp < 0)
                    v_result <= 0;
                else if (interp_tmp > 255)
                    v_result <= 255;
                else
                    v_result <= interp_tmp[7:0] + ((interp_tmp[7:0] & 8'h80) ? 8'd1 : 8'd0);
            end

            WRITE: begin
                // Write result to SRAM
                sram_cen <= 1'b0;
                sram_wen <= 1'b0;
                
                // Calculate SRAM address (ty * tw_reg + tx)
                // Use shifts and additions instead of multiplication
                // Example: ty * tw_reg = ty * 16 = ty << 4
                if (tw_reg == 6'd8)
                    sram_addr <= {ty, 3'b0} + tx;
                else if (tw_reg == 6'd16)
                    sram_addr <= {ty, 4'b0} + tx;
                else if (tw_reg == 6'd32)
                    sram_addr <= {ty, 5'b0} + tx;
                else
                    // For non-power-of-2, use a more general method
                    // Example: ty * 19 = ty * 16 + ty * 2 + ty * 1 = (ty << 4) + (ty << 1) + ty
                    sram_addr <= ({ty, 5'b0} >> (6'd32 / tw_reg)) + tx;
                
                sram_data <= v_result[7:0];
            end

            NEXT_PIXEL: begin
                // Disable SRAM
                sram_cen <= 1'b1;
                sram_wen <= 1'b1;
                
                // Update target coordinates
                if (tx < tw_reg - 1) begin
                    tx <= tx + 1;
                    // Increase x position
                    pos_x <= pos_x + dx_acc;
                end else begin
                    tx <= 0;
                    ty <= ty + 1;
                    // Reset x position, increase y position
                    pos_x <= {h0_reg, 8'b0};
                    pos_y <= pos_y + dy_acc;
                end
            end

            DONE_STATE: begin
                DONE <= 1'b1;
                rom_cen <= 1'b1;
                sram_cen <= 1'b1;
                sram_wen <= 1'b1;
            end
        endcase
    end
end

endmodule