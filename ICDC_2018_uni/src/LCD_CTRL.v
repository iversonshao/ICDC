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

reg [7:0] temp_max, temp_min, temp_avg;
reg [7:0] temp [0:3]; // Array to store 4 temporary values
reg [5:0] temp_idx1, temp_idx2, temp_idx3, temp_idx4;

parameter READ = 2'd0, IDLE = 2'd1, PROCESS = 2'd2, WRITE = 2'd3;

parameter Write = 4'd0;
parameter Shift_Up = 4'd1, Shift_Down = 4'd2, Shift_Left = 4'd3, Shift_Right = 4'd4;
parameter Max = 4'd5, Min = 4'd6, Avg = 4'd7;
parameter Counterclockwise = 4'd8, Clockwise = 4'd9;
parameter Mirror_X = 4'd10, Mirror_Y = 4'd11;

reg [1:0] state, next_state;
reg [7:0] image [0:63];
reg [5:0] read_cnt;
reg [6:0] write_cnt;
reg [3:0] current_cmd; // Store current command
reg process_phase; // For distinguishing between two processing phases

reg [2:0] x_point, y_point; // operation point, init at (4,4)

// State transition logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= READ;
    end else begin
        state <= next_state;
    end
end

// Next state determination
always @(*) begin
    case(state)
        READ:
            if (read_cnt == 6'd63) begin
                next_state = IDLE;
            end else begin
                next_state = READ;
            end
        IDLE:
            if (cmd_valid && cmd == Write) begin
                next_state = WRITE;
            end else if (cmd_valid && cmd != Write) begin
                next_state = PROCESS;
            end else begin
                next_state = IDLE;
            end
        PROCESS:
            if ((current_cmd == Counterclockwise || current_cmd == Clockwise || 
                 current_cmd == Mirror_X || current_cmd == Mirror_Y) && !process_phase) begin
                next_state = PROCESS; // These operations need two clock cycles
            end else begin
                next_state = IDLE;
            end
        WRITE:
            if (done) begin
                next_state = IDLE;
            end else begin
                next_state = WRITE;
            end
        default:
            next_state = READ;
    endcase
end

// Calculate indices around operation point and various operation values
always @(*) begin
    // Calculate indices for the 2x2 pixel block around operation point
    // Ensure we're accessing valid memory locations
    temp_idx1 = ((y_point - 1) << 3) + (x_point - 1); // Top-left (0,0)
    temp_idx2 = ((y_point - 1) << 3) + x_point;       // Top-right (0,1)
    temp_idx3 = (y_point << 3) + (x_point - 1);       // Bottom-left (1,0)
    temp_idx4 = (y_point << 3) + x_point;             // Bottom-right (1,1)

    // Compute Max, Min, Avg values
    temp_max = 8'd0;
    temp_min = 8'd255;
    temp_avg = 8'd0;
    
    if (current_cmd == Max) begin
        // Find maximum value among the 4 pixels
        temp_max = image[temp_idx1];
        if (image[temp_idx2] > temp_max) temp_max = image[temp_idx2];
        if (image[temp_idx3] > temp_max) temp_max = image[temp_idx3];
        if (image[temp_idx4] > temp_max) temp_max = image[temp_idx4];
    end
    else if (current_cmd == Min) begin
        // Find minimum value among the 4 pixels
        temp_min = image[temp_idx1];
        if (image[temp_idx2] < temp_min) temp_min = image[temp_idx2];
        if (image[temp_idx3] < temp_min) temp_min = image[temp_idx3];
        if (image[temp_idx4] < temp_min) temp_min = image[temp_idx4];
    end
    else if (current_cmd == Avg) begin
        // Calculate average (truncated, not rounded)
        temp_avg = (image[temp_idx1] + image[temp_idx2] + image[temp_idx3] + image[temp_idx4]) >> 2;
    end
end

// Main FSM and operations
always @(posedge clk or posedge reset) begin
    if (reset) begin
        read_cnt <= 0;
        write_cnt <= 0;
        IROM_rd <= 1;
        IROM_A <= 0;
        busy <= 1;
        done <= 0;
        IRAM_valid <= 0;
        x_point <= 4;  // Initialize operation point to (4,4)
        y_point <= 4;
        current_cmd <= 0;
        process_phase <= 0;
    end else begin
        case(state)
            READ: begin
                // Read image data from IROM
                done <= 0;
                busy <= 1;
                IROM_rd <= 1;
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
                // Wait for commands and set control signals
                IROM_rd <= 0;
                IRAM_valid <= 0;
                busy <= 0;
                done <= 0;
                process_phase <= 0;
                
                if (cmd_valid) begin
                    busy <= 1; // Set busy when receiving a command
                    current_cmd <= cmd; // Store the current command
                end
            end
            PROCESS: begin
                busy <= 1;
                if (!process_phase) begin
                    // First phase processing
                    case(current_cmd)
                        Shift_Up: begin
                            // Move operation point up, but not beyond boundary (y=1)
                            if (y_point > 3'd1) begin
                                y_point <= y_point - 1'b1;
                            end
                        end
                        Shift_Down: begin
                            // Move operation point down, but not beyond boundary (y=7)
                            if (y_point < 3'd7) begin
                                y_point <= y_point + 1'b1;
                            end
                        end
                        Shift_Left: begin
                            // Move operation point left, but not beyond boundary (x=1)
                            if (x_point > 3'd1) begin
                                x_point <= x_point - 1'b1;
                            end
                        end
                        Shift_Right: begin
                            // Move operation point right, but not beyond boundary (x=7)
                            if (x_point < 3'd7) begin
                                x_point <= x_point + 1'b1;
                            end
                        end
                        Max: begin
                            // Apply maximum value to all four pixels
                            image[temp_idx1] <= temp_max;
                            image[temp_idx2] <= temp_max;
                            image[temp_idx3] <= temp_max;
                            image[temp_idx4] <= temp_max;
                        end
                        Min: begin
                            // Apply minimum value to all four pixels
                            image[temp_idx1] <= temp_min;
                            image[temp_idx2] <= temp_min;
                            image[temp_idx3] <= temp_min;
                            image[temp_idx4] <= temp_min;
                        end
                        Avg: begin
                            // Apply average value to all four pixels
                            image[temp_idx1] <= temp_avg;
                            image[temp_idx2] <= temp_avg;
                            image[temp_idx3] <= temp_avg;
                            image[temp_idx4] <= temp_avg;
                        end
                        Counterclockwise, Clockwise, Mirror_X, Mirror_Y: begin
                            // First phase: Save current values to temporary array
                            // Make sure all indices are valid to prevent out-of-bounds access
                            if (temp_idx1 < 64 && temp_idx2 < 64 && temp_idx3 < 64 && temp_idx4 < 64) begin
                                temp[0] <= image[temp_idx1]; // Top-left
                                temp[1] <= image[temp_idx2]; // Top-right
                                temp[2] <= image[temp_idx3]; // Bottom-left
                                temp[3] <= image[temp_idx4]; // Bottom-right
                                process_phase <= 1; // Set for second phase
                            end else begin
                                // Skip operation if any index is invalid
                                process_phase <= 0;
                            end
                        end
                    endcase
                end else begin
                    // Second phase processing (for operations that need two phases)
                    process_phase <= 0; // Reset phase for next operation
                    case(current_cmd)
                        Counterclockwise: begin
                            // Counterclockwise rotation (90 degrees anti-clockwise)
                            // Pixel mapping:
                            // 0 1    1 3
                            // 2 3 -> 0 2
                            image[temp_idx1] <= temp[1]; // Top-Left = Original Top-Right
                            image[temp_idx2] <= temp[3]; // Top-Right = Original Bottom-Right
                            image[temp_idx3] <= temp[0]; // Bottom-Left = Original Top-Left
                            image[temp_idx4] <= temp[2]; // Bottom-Right = Original Bottom-Left
                        end
                        Clockwise: begin
                            // Clockwise rotation (90 degrees clockwise)
                            // Pixel mapping:
                            // 0 1    2 0
                            // 2 3 -> 3 1
                            image[temp_idx1] <= temp[2]; // Top-Left = Original Bottom-Left
                            image[temp_idx2] <= temp[0]; // Top-Right = Original Top-Left
                            image[temp_idx3] <= temp[3]; // Bottom-Left = Original Bottom-Right
                            image[temp_idx4] <= temp[1]; // Bottom-Right = Original Top-Right
                        end
                        Mirror_X: begin
                            // X-axis mirror (horizontal axis, swap top and bottom)
                            // Pixel mapping:
                            // 0 1    2 3
                            // 2 3 -> 0 1
                            image[temp_idx1] <= temp[2]; // Top-Left = Original Bottom-Left
                            image[temp_idx2] <= temp[3]; // Top-Right = Original Bottom-Right
                            image[temp_idx3] <= temp[0]; // Bottom-Left = Original Top-Left
                            image[temp_idx4] <= temp[1]; // Bottom-Right = Original Top-Right
                        end
                        Mirror_Y: begin
                            // Y-axis mirror (vertical axis, swap left and right)
                            // Pixel mapping:
                            // 0 1    1 0
                            // 2 3 -> 3 2
                            image[temp_idx1] <= temp[1]; // Top-Left = Original Top-Right
                            image[temp_idx2] <= temp[0]; // Top-Right = Original Top-Left
                            image[temp_idx3] <= temp[3]; // Bottom-Left = Original Bottom-Right
                            image[temp_idx4] <= temp[2]; // Bottom-Right = Original Bottom-Left
                        end
                    endcase
                end
            end
            WRITE: begin
                // Write processed image to IRAM
                busy <= 1;
                done <= 0;

                if (write_cnt < 7'd64) begin
                    write_cnt <= write_cnt + 1;
                    IRAM_valid <= 1;
                    IRAM_A <= write_cnt;
                    IRAM_D <= image[write_cnt];
                end else begin
                    IRAM_valid <= 0;
                    done <= 1;
                    busy <= 0;
                    write_cnt <= 0;
                end
            end
            default: begin
                // Default reset state
                read_cnt <= 0;
                IROM_rd <= 1;
                IROM_A <= 0;
                busy <= 1;
                done <= 0;
            end
        endcase
    end
end
endmodule
