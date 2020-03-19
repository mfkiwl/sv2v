module Producer(clock, data);
    parameter INIT = 0;
    input logic clock;
    output logic [10:0] data [5];
    initial data[0][0] = INIT;
    always @(clock) begin
        integer i, j;
        for (i = 4; i >= 0; i--) begin
            for (j = 9; j >= 0; j--) begin
                data[i][j + 1] = data[i][j];
            end
            if (i != 0)
                data[i][0] = data[i-1][10];
        end
        data[0][0] = ~data[0][0];
    end
endmodule

module top;
    reg clock;
    initial begin
        clock = 1;
        repeat (100)
            #1 clock = ~clock;
    end

    logic [10:0] foo [5];
    Producer #(.INIT(0)) p1(clock, foo);

    logic [10:0] bar [10];
    Producer #(.INIT(0)) p2(clock, bar[0:4]);
    Producer #(.INIT(1)) p3(clock, bar[5:9]);

    initial
        $monitor("%d %b%b%b%b%b %b%b%b%b%b%b%b%b%b%b", $time,
            foo[0], foo[1], foo[2], foo[3], foo[4],
            bar[0], bar[1], bar[2], bar[3], bar[4],
            bar[5], bar[6], bar[7], bar[8], bar[9]
        );
endmodule
