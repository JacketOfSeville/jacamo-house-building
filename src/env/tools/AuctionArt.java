package tools;

import cartago.Artifact;
import cartago.INTERNAL_OPERATION;
import cartago.OPERATION;
import cartago.ObsProperty;

/**
 *      Artefato que implementa o leilão.
 */
public class AuctionArt extends Artifact {


    @OPERATION public void init(String taskDs, int maxValue, int maxTime)  {
        // Propriedades observaveis
        defineObsProperty("task",          taskDs);
        defineObsProperty("maxValue",      maxValue);
        defineObsProperty("currentBid",    maxValue);
        defineObsProperty("currentWinner", "no_winner");

        defineObsProperty("maxTime", maxTime); // Tempo máximo
        defineObsProperty("time", 0); // Tempo

        execInternalOp("advanceTimePeriodically");

        // Não é mais necessaria agora que usamos a propriedade time
        // defineObsProperty("state", "open");
    }

    @OPERATION public void bid(double bidValue) {
        // Não necessaria  a propriedade time
        // if (getObsProperty("state").stringValue() == "closed") {
        //     failed("Auction is closed");
        // }
        if (getObsProperty("time").intValue() > getObsProperty("maxTime").intValue()) {
            failed("Max time exceeded");
            return;
        }

        ObsProperty opCurrentValue  = getObsProperty("currentBid");
        ObsProperty opCurrentWinner = getObsProperty("currentWinner");
        if (bidValue < opCurrentValue.doubleValue()) {  // o lance é melhor que o anterior
            opCurrentValue.updateValue(bidValue);
            opCurrentWinner.updateValue(getCurrentOpAgentId().getAgentName());
        }
    }

    @INTERNAL_OPERATION
    void advanceTimePeriodically() {
        while (true) {
            await_time(1000); // Espere 1 segundo
            ObsProperty timeProp = getObsProperty("time");
            int currentTime = timeProp.intValue();
            timeProp.updateValue(currentTime + 1); // atualiza o tempo

            if (currentTime + 1 > getObsProperty("maxTime").intValue()) {
                // Pare o avanço do tempo se o tempo máximo for atingido
                break;
            }
        }
    }


    // Não é mais necessaria agora que usamos a propriedade time
    // @OPERATION public void clearAuction() {
    //     defineObsProperty("state", "closed");
    // }

}

