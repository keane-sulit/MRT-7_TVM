`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Bettina Dayrit, Gia Guevarra, Randell Lariza, Mariah Rodriguez, Keane Sulit
// 
// Create Date: 27.11.2023 01:52:20
// Design Name: 
// Module Name: TicketVendingMachine
// Project Name: MRT-7 Ticket Vending Machine
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TicketVendingMachine(
    input [3:0] stationSelector,    // 4-bit input for station selection
    input [7:0] userPayment,        // 8-bit input for user payment amount
    input startTransaction,         // Input signal to initiate the transaction
    
    output reg [7:0] ticketPrice,   // 8-bit output for calculated ticket price
    output reg [3:0] issuedTicket,  // 4-bit output for the issued ticket type
    output reg transactionComplete  // Output signal indicating transaction completion
    );
    
    // Declare internal parameters for fare matrix and ticket types
    parameter BASE_FARE = 10;   // Example base fare amount
    parameter ADDITIONAL_FARE_PER_STATION = 5;  // Example additional fare per station
    
    // Internal variables
    reg [7:0] fare;     // Variable to store the calculated fare
    
    // State machine definition
    parameter IDLE = 3'b000;
    parameter PROCESSING = 3'b001;
    parameter COMPLETED = 3'b010;
    
    reg [2:0] currentState; // Variable to store the current state of the state machine

always @(posedge startTransaction) begin
    // State machine transitions
    case (currentState)
        IDLE: currentState <= PROCESSING;
        PROCESSING: currentState <= COMPLETED;
        COMPLETED: currentState <= IDLE;
        default: currentState <= IDLE;
    endcase
end

always @(posedge startTransaction) begin
    // Functional logic based on the current state
    case (currentState)
        IDLE: begin
            // Reset internal variables when IDLE
            ticketPrice <= 0;
            issuedTicket <= 0;
            transactionComplete <= 0;
        end
        PROCESSING: begin
            // Calculate fare based on station selection and user payment
            fare <= BASE_FARE + (ADDITIONAL_FARE_PER_STATION * stationSelector);

            // Determine the ticket type based on fare
            if (userPayment >= fare) begin
                issuedTicket <= stationSelector;
                ticketPrice <= fare;
            end else begin
                // Handle insufficient payment scenario
                issuedTicket <= 0;
                ticketPrice <= 0;
            end

            // Set transaction completion signal
            transactionComplete <= 1;
        end
        COMPLETED: begin
            // Reset transaction completion signal
            transactionComplete <= 0;
        end
    endcase
end

    
endmodule
