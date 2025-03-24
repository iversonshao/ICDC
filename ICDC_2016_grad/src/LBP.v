`timescale 1ns/10ps
module LBP ( clk, reset, gray_addr, gray_req, gray_ready, gray_data, lbp_addr, lbp_valid, lbp_data, finish);
input clk;
input reset;
output reg [13:0] gray_addr;
output reg gray_req;
input gray_ready;
input [7:0] gray_data;
output reg [13:0] lbp_addr;
output reg lbp_valid;
output reg [7:0] lbp_data;
output reg finish;
//====================================================================
reg [2:0] state, next_state;
reg [6:0] row, col;
reg [3:0] read_count;
reg [7:0] pixel_buffer[0:8];
reg [7:0] lbp_result;

parameter IDLE = 3'd0,
          READ = 3'd1,
          COMPUTE = 3'd2,
          WRITE = 3'd3,
          DONE = 3'd4;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end    
end

always @(*) begin
    case(state)
        IDLE: begin
            if (gray_ready) begin
                next_state = READ;
            end else begin
                next_state = IDLE;
            end
        end
        READ: begin
            if (read_count >= 9) begin
                next_state = COMPUTE;
            end else begin
                next_state = READ;
            end
        end
        COMPUTE:
            next_state = WRITE;
        WRITE: begin
            if (row == 126 && col == 126) begin
                next_state = DONE;
            end else begin
                next_state = READ;
            end
        end
        DONE:
            next_state = DONE;
        default:
            next_state = IDLE;
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        gray_req <= 1'b0;
        gray_addr <= 14'd0;
        lbp_addr <= 14'd0;
        lbp_valid <= 1'b0;
        lbp_data <= 8'd0;
        finish <= 1'b0;
        row <= 7'd1;
        col <= 7'd1;
        read_count <= 4'd0;
        lbp_result <= 8'd0;
        
        // 初始化所有像素缓冲区为0
        pixel_buffer[0] <= 8'd0;
        pixel_buffer[1] <= 8'd0;
        pixel_buffer[2] <= 8'd0;
        pixel_buffer[3] <= 8'd0;
        pixel_buffer[4] <= 8'd0;
        pixel_buffer[5] <= 8'd0;
        pixel_buffer[6] <= 8'd0;
        pixel_buffer[7] <= 8'd0;
        pixel_buffer[8] <= 8'd0;
    end else begin
        case(state)
            IDLE: begin
                finish <= 1'b0;
                if (gray_ready) begin
                    gray_req <= 1'b1;
                    read_count <= 4'd0;
                end else begin
                    gray_req <= 1'b0;
                end
                lbp_valid <= 1'b0;
            end
            READ: begin
                lbp_valid <= 1'b0;
                case(read_count)
                    0: gray_addr <= (row-7'd1)*8'd128 + (col-7'd1); // top left
                    1: gray_addr <= (row-7'd1)*8'd128 + col; // top
                    2: gray_addr <= (row-7'd1)*8'd128 + (col+7'd1); // top right
                    3: gray_addr <= row * 8'd128 + (col-7'd1); // left
                    4: gray_addr <= row * 8'd128 + col; // center
                    5: gray_addr <= row * 8'd128 + (col+7'd1); // right
                    6: gray_addr <= (row+7'd1)*8'd128 + (col-7'd1); // bottom left
                    7: gray_addr <= (row+7'd1)*8'd128 + col; // bottom
                    8: gray_addr <= (row+7'd1)*8'd128 + (col+7'd1); // bottom right
                    default: gray_addr <= 14'd0;
                endcase
                if (read_count < 4'd9) begin
                    if (read_count > 4'd0) begin
                        pixel_buffer[read_count-4'd1] <= gray_data;
                    end
                    read_count <= read_count + 4'd1;
                    gray_req <= 1'b1;
                end else begin
                    gray_req <= 1'b0;
                end
            end
            COMPUTE: begin
                pixel_buffer[8] <= gray_data;
                lbp_valid <= 1'b0;
                gray_req <= 1'b0;
                

                lbp_result <= ((pixel_buffer[0] >= pixel_buffer[4]) ? 8'h01 : 8'h00) |
                            ((pixel_buffer[1] >= pixel_buffer[4]) ? 8'h02 : 8'h00) |
                            ((pixel_buffer[2] >= pixel_buffer[4]) ? 8'h04 : 8'h00) |
                            ((pixel_buffer[3] >= pixel_buffer[4]) ? 8'h08 : 8'h00) |
                            ((pixel_buffer[5] >= pixel_buffer[4]) ? 8'h10 : 8'h00) |
                            ((pixel_buffer[6] >= pixel_buffer[4]) ? 8'h20 : 8'h00) |
                            ((pixel_buffer[7] >= pixel_buffer[4]) ? 8'h40 : 8'h00) |
                            ((gray_data >= pixel_buffer[4]) ? 8'h80 : 8'h00);
            end
            WRITE: begin
                lbp_valid <= 1'b1;
                lbp_addr <= row * 8'd128 + col;
                
                if (row == 7'd0 || row == 7'd127 || col == 7'd0 || col == 7'd127) begin
                    lbp_data <= 8'd0;
                end else begin
                    lbp_data <= lbp_result;
                end

                if (col < 7'd127) begin
                    col <= col + 1;
                end else begin
                    col <= 7'd0;
                    row <= row + 7'd1;
                end
                read_count <= 4'd0;
                gray_req <= 1'b1;
            end
            DONE: begin
                finish <= 1'b1;
                lbp_valid <= 1'b0;
                gray_req <= 1'b0;
            end
            default: begin
                lbp_valid <= 1'b0;
                gray_req <= 1'b0;
                finish <= 1'b0;
            end
        endcase
    end
end
//====================================================================
endmodule
