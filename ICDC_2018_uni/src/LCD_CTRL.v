module LCD_CTRL (clk, reset, cmd, cmd_valid, 
                IROM_Q, IROM_rd, IROM_A,
                IRAM_valid, IRAM_D, IRAM_A,
                busy, done);
input clk, reset;
input [3:0] cmd;
input cmd_valid;
input [7:0] IROM_Q;
output reg IROM_rd;
output reg [5:0] IROM_A;
output reg IRAM_valid;
output reg [7:0] IRAM_D;
output reg [5:0] IRAM_A;
output reg busy, done;

reg [7:0] temp_max, temp_min, temp_avg, temp, temp1;
reg [5:0] temp_idx1, temp_idx2, temp_idx3, temp_idx4;

parameter INIT = 3'd0, READ = 3'd1, IDLE = 3'd2, PROCESS = 3'd3, WRITE = 3'd4;

parameter Write = 4'd0;
parameter Shift_Up = 4'd1, Shift_Down = 4'd2, Shift_Left = 4'd3, Shift_Right = 4'd4;
parameter Max = 4'd5, Min = 4'd6, Avg = 4'd7;
parameter Counterclockwise = 4'd8, Clockwise = 4'd9;
parameter Mirror_X = 4'd10, Mirror_Y = 4'd11;

reg [2:0] state, next_state;
reg [7:0] image [0:63];
reg [5:0] read_cnt;
reg [5:0] write_cnt;

reg [2:0] x_point, y_point; // init (4,4)
// state switch
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= INIT;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        INIT: 
            next_state = READ;
        READ:
            if (read_cnt == 6'd63) begin
                next_state = IDLE;
            end else begin
                next_state = READ;
            end
        IDLE:
            if (cmd_valid) begin
                if (cmd == Write) begin
                    next_state = WRITE;
                end else begin
                    next_state = PROCESS;
                end
            end else begin
                next_state = IDLE;
            end
        PROCESS:
            next_state = IDLE;
        WRITE:
            if (write_cnt == 6'd63) begin
                next_state = IDLE;
            end else begin
                next_state = WRITE;
            end
        default :
            next_state = INIT;
    endcase
end

always @(*) begin
    temp_idx1 = ((y_point - 1) << 3) + (x_point - 1); //(0,0)
    temp_idx2 = ((y_point - 1) << 3) + x_point; //(0,1)
    temp_idx3 = (y_point << 3) + (x_point - 1); //(1,0)
    temp_idx4 = (y_point << 3) + x_point; //(1,1)
end

always @(*) begin
    temp_max = 8'd0;
    temp_min = 8'd255;
    temp_avg = 8'd0;
    
    case(cmd)
        Max: begin
            temp_max = image[temp_idx1];
            if (image[temp_idx2] > temp_max) temp_max = image[temp_idx2];
            if (image[temp_idx3] > temp_max) temp_max = image[temp_idx3];
            if (image[temp_idx4] > temp_max) temp_max = image[temp_idx4];
        end
        Min: begin
            temp_min = image[temp_idx1];
            if (image[temp_idx2] < temp_min) temp_min = image[temp_idx2];
            if (image[temp_idx3] < temp_min) temp_min = image[temp_idx3];
            if (image[temp_idx4] < temp_min) temp_min = image[temp_idx4];
        end
        Avg:
            temp_avg = (image[temp_idx1] + image[temp_idx2] + image[temp_idx3] + image[temp_idx4]) >> 2;
    endcase
end
always @(posedge clk or posedge reset) begin
    if (reset) begin
        read_cnt <= 0;
        write_cnt <= 0;
        IROM_rd <= 1;
        IROM_A <= 0;
        busy <= 1;
        IRAM_valid <= 0;
        done <= 0;
        x_point <= 4;
        y_point <= 4;
    end else begin
        case(state)
            INIT: begin
                read_cnt <= 0;
                IROM_rd <= 1;
                IROM_A <= 0;
                busy <= 1;
            end
            READ: begin
                image[read_cnt] <= IROM_Q;
                if (read_cnt < 6'd63) begin
                    read_cnt <= read_cnt + 1;
                    IROM_A <= read_cnt + 1;
                end else begin
                    IROM_rd <= 0;
                    busy <= 0;
                end
            end
            IDLE: begin
                if (cmd_valid) begin
                    busy <= 1;
                end
            end
            PROCESS: begin
                if (cmd_valid) begin
                    busy <= 1'b1;
                end
                case(cmd)  // 移除錯誤的begin
                    Shift_Up: begin
                        if (y_point > 3'd1) begin
                            y_point <= y_point - 1'b1;
                        end
                    end
                    Shift_Down: begin
                        if (y_point < 3'd7) begin
                            y_point <= y_point + 1'b1;
                        end
                    end
                    Shift_Left: begin
                        if (x_point > 3'd1) begin
                            x_point <= x_point - 1'b1;
                        end
                    end
                    Shift_Right: begin
                        if (x_point < 3'd7) begin
                            x_point <= x_point + 1'b1;
                        end
                    end
                    Max: begin
                        // y_point*8 + x_point is address
                        image[temp_idx1] <= temp_max;
                        image[temp_idx2] <= temp_max;
                        image[temp_idx3] <= temp_max;
                        image[temp_idx4] <= temp_max;
                    end
                    Min: begin
                        image[temp_idx1] <= temp_min;
                        image[temp_idx2] <= temp_min;
                        image[temp_idx3] <= temp_min;
                        image[temp_idx4] <= temp_min;
                    end
                    Avg: begin
                        image[temp_idx1] <= temp_avg;
                        image[temp_idx2] <= temp_avg;
                        image[temp_idx3] <= temp_avg;
                        image[temp_idx4] <= temp_avg;
                    end
                    Counterclockwise: begin
                        // 0,0 -> 0,1 -> 1,1 -> 1,0 -> 0,0
                        temp <= image[temp_idx1];
                        image[temp_idx1] <= image[temp_idx2];
                        image[temp_idx2] <= image[temp_idx4];
                        image[temp_idx4] <= image[temp_idx3];
                        image[temp_idx3] <= temp;
                    end
                    Clockwise: begin
                        // 0,0 -> 1,0 -> 1,1 -> 0,1 -> 0,0
                        temp <= image[temp_idx1];
                        image[temp_idx1] <= image[temp_idx3];
                        image[temp_idx3] <= image[temp_idx4];
                        image[temp_idx4] <= image[temp_idx2];
                        image[temp_idx2] <= temp;
                    end
                    Mirror_X: begin
                        // 0,0 , 1,0 <-> 0,1 , 1,1
                        temp <= image[temp_idx1];
                        image[temp_idx1] <= image[temp_idx3];
                        image[temp_idx3] <= temp;
                        temp1 <= image[temp_idx2];
                        image[temp_idx2] <= image[temp_idx4];
                        image[temp_idx4] <= temp1;
                    end
                    Mirror_Y: begin
                        // 0,0 , 1,0 <-> 0,1 , 1,1
                        temp <= image[temp_idx1];
                        image[temp_idx1] <= image[temp_idx2];
                        image[temp_idx2] <= temp;
                        temp1 <= image[temp_idx3];
                        image[temp_idx3] <= image[temp_idx4];
                        image[temp_idx4] <= temp1;
                    end
                endcase
                busy <= 1'b0;
            end
            WRITE: begin
                IRAM_valid <= 1;
                IRAM_A <= write_cnt;
                IRAM_D <= image[write_cnt];
                if (write_cnt < 6'd63) begin
                    write_cnt <= write_cnt + 1;
                end else begin
                    IRAM_valid <= 0;
                    busy <= 0;
                    done <= 1;
                    write_cnt <= 0;
                end
            end
            default: begin
                read_cnt <= 0;
                IROM_rd <= 1;
                IROM_A <= 0;
                busy <= 0;
                done <= 1;
            end
        endcase
    end
end
endmodule