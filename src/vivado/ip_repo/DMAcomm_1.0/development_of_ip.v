`define WRITE_ON_LOW_BANK 1’b0
`define WRITE_ON_HIGH_BANK 1’b1

if (init)
	If (pointer==LOW_BANK_HIGH_MEM+1)
		bank = `WRITE_ON_HIGH_BANK
                        init = 0

else
if (addr_monitor is in LOW_BANK_RANGE) and (bank==`WRITE_ON_LOW_BANK) then:
	bank=WRITE_ON_HIGH_BANK
	high_mem=HIGH_BANK_HIGH_MEM


if (addr_monitor  is in HIGH_BANK_RANGE) and (bank==`WRITE_ON_HIGH_BANK) then:
	bank=WRITE_ON_LOW_BANK
	high mem=LOW_BANK_HIGH_MEM



assign fifo_wren = S_AXIS_TVALID && axis_tready;
assign axis_tready = ((mst_exec_state == WRITE_FIFO) && (write_pointer <= high_mem));

init (only when everything starts is on high)

writes_done puts the main state machine into IDLE
