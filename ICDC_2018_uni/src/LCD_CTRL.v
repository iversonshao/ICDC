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
    temp_idx1 = ((y_point - 1'd1) << 3) + (x_point - 1'd1); //(0,0)
    temp_idx2 = ((y_point - 1'd1) << 3) + x_point; //(0,1)
    temp_idx3 = (y_point << 3) + (x_point - 1'd1); //(1,0)
    temp_idx4 = (y_point << 3) + x_point; //(1,1)
    case(cmd)
        Max:
            temp_max = image[temp_idx1];
            if (image[temp_idx2] > temp_max) begin
                temp_max = image[temp_idx2];
            end
            if (image[temp_idx3] > temp_max) begin
                temp_max = image[temp_idx3];
            end
            if (image[temp_idx4] > temp_max) begin
                temp_max = image[temp_idx4];
            end
        Min:
            temp_min = image[temp_idx1];
            if (image[temp_idx2] < temp_min) begin
                temp_min = image[temp_idx2];
            end
            if (image[temp_idx3] < temp_min) begin
                temp_min = image[temp_idx3];
            end
            if (image[temp_idx4] < temp_min) begin
                temp_min = image[temp_idx4];
            end
        Avg:
            temp_avg = (image[temp_idx1] + image[temp_idx2] + image[temp_idx3] + image[temp_idx4]) >> 2;
        default:
            temp_max = 8'd0;
            temp_min = 8'd255;
            temp_avg = 8'd0;
    endcase
end
always @(posedge clk or posedge reset) begin
    if (reset) begin
        read_cnt <= 6'd0;
        write_cnt <= 6'd0;
        IROM_rd <= 1'b1;
        IROM_A <= 6'd0;
        busy <= 1'b1;
        IRAM_valid <= 1'b0;
        done <= 1'b0;
        x_point <= 3'd4;
        y_point <= 3'd4;
    end else begin
        case(state)
            INIT:
                read_cnt <= 6'd0;
                IROM_rd <= 1'b1;
                IROM_A <= 6'd0;
                busy <= 1'b1;
            READ:
                image[read_cnt] <= IROM_Q;
                if (read_cnt < 6'd63) begin
                    read_cnt <= read_cnt + 1'b1;
                    IROM_A <= read_cnt + 1'b1;
                end else begin
                    IROM_rd <= 1'b0;
                    busy <= 1'b0;
                end
            IDLE:
                if (cmd_valid) begin
                    busy <= 1'b1;
                end
            PROCESS:
                if (cmd_valid) begin
                    busy <= 1'b1;
                end
                case(cmd)
                    Shift_Up:
                        if (y_point > 3'd1) begin
                            y_point <= y_point - 1'b1;
                        end
                    Shift_Down:
                        if (y_point < 3'd7) begin
                            y_point <= y_point + 1'b1;
                        end
                    Shift_Left:
                        if (x_point > 3'd1) begin
                            x_point <= x_point - 1'b1;
                        end
                    Shift_Right:
                        if (x_point < 3'd7) begin
                            x_point <= x_point + 1'b1;
                        end
                    Max:
                        // y_point*8 + x_point is address
                        image[temp_idx1] <= temp_max;
                        image[temp_idx2] <= temp_max;
                        image[temp_idx3] <= temp_max;
                        image[temp_idx4] <= temp_max;
                    Min:
                        image[temp_idx1] <= temp_min;
                        image[temp_idx2] <= temp_min;
                        image[temp_idx3] <= temp_min;
                        image[temp_idx4] <= temp_min;
                    Avg:
                        image[temp_idx1] <= temp_avg;
                        image[temp_idx2] <= temp_avg;
                        image[temp_idx3] <= temp_avg;
                        image[temp_idx4] <= temp_avg;
                    Counterclockwise:
                        // 0,0 -> 0,1 -> 1,1 -> 1,0 -> 0,0
                        temp <= image[temp_idx1];
                        image[temp_idx1] <= image[temp_idx2];
                        image[temp_idx2] <= image[temp_idx4];
                        image[temp_idx4] <= image[temp_idx3];
                        image[temp_idx3] <= temp;
                    Clockwise:
                        // 0,0 -> 1,0 -> 1,1 -> 0,1 -> 0,0
                        temp <= image[temp_idx1];
                        image[temp_idx1] <= image[temp_idx3];
                        image[temp_idx3] <= image[temp_idx4];
                        image[temp_idx4] <= image[temp_idx2];
                        image[temp_idx2] <= temp;
                    Mirror_X:
                        // 0,0 , 1,0 <-> 0,1 , 1,1
                        temp <= image[temp_idx1];
                        image[temp_idx1] <= image[temp_idx3];
                        image[temp_idx3] <= temp;
                        temp1 <= image[temp_idx2];
                        image[temp_idx2] <= image[temp_idx4];
                        image[temp_idx4] <= temp1;
                    Mirror_Y:
                        // 0,0 , 1,0 <-> 0,1 , 1,1
                        temp <= image[temp_idx1];
                        image[temp_idx1] <= image[temp_idx2];
                        image[temp_idx2] <= temp;
                        temp1 <= image[temp_idx3];
                        image[temp_idx3] <= image[temp_idx4];
                        image[temp_idx4] <= temp1;
                endcase
                busy <= 1'b0;
            WRITE:
                IRAM_valid <= 1'b1;
                IRAM_A <= write_cnt;
                IRAM_D <= image[write_cnt];
                if (write_cnt < 6'd63) begin
                    write_cnt <= write_cnt + 1'b1;
                end else begin
                    IRAM_valid <= 1'b0;
                    busy <= 1'b0;
                    done <= 1'b1;
                    write_cnt <= 6'd0;
                end
            default:
                read_cnt <= 6'd0;
                IROM_rd <= 1'b1;
                IROM_A <= 6'd0;
                busy <= 1'b0;
                done <= 1'b1;
        endcase
    end
end
endmodule