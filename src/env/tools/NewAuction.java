package tools;

import cartago.Artifact;
import cartago.INTERNAL_OPERATION;
import cartago.OPERATION;
import cartago.ObsProperty;

/**
 *  Artefato que implementa o leilão.
 */
public class NewAuction extends Artifact {

    @OPERATION public void init(String taskDs, int maxValue, int maxTime)  {
        defineObsProperty("task",          taskDs);
        defineObsProperty("maxValue",      maxValue);
        defineObsProperty("currentBid",    maxValue);
        defineObsProperty("currentWinner", "no_winner");

        defineObsProperty("maxTime", maxTime);
        defineObsProperty("time", 0);

        execInternalOp("advanceTimePeriodically");

    }

    @OPERATION public void bid(double bidValue) {
        if (getObsProperty("time").intValue() > getObsProperty("maxTime").intValue()) {
            failed("Max time exceeded");
            return;
        }

        ObsProperty opCurrentValue  = getObsProperty("currentBid");
        ObsProperty opCurrentWinner = getObsProperty("currentWinner");
        // Ele aceita uma taxa extra
        final var tax = 20;
        if (bidValue < opCurrentValue.doubleValue() + tax) {
            opCurrentValue.updateValue(bidValue);
            opCurrentWinner.updateValue(getCurrentOpAgentId().getAgentName());
        }
    }

    @INTERNAL_OPERATION void advanceTimePeriodically() {
        while (true) {
            await_time(1000); // Espera por 1 segundo
            ObsProperty timeProp = getObsProperty("time"); 
            int currentTime = timeProp.intValue(); // Armazena o tempo atual como 
            timeProp.updateValue(currentTime + 1);

            if (currentTime + 1 > getObsProperty("maxTime").intValue()) {
                break;
            }
        }
    }
}

