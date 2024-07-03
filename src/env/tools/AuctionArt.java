package tools;

import cartago.Artifact;
import cartago.OPERATION;
import cartago.ObsProperty;

/**
 *      Artefato que implementa o leilão.
 */
public class AuctionArt extends Artifact {


    @OPERATION public void init(String taskDs, int maxValue)  {
        // Propriedades observaveis
        defineObsProperty("task",          taskDs);
        defineObsProperty("maxValue",      maxValue);
        defineObsProperty("currentBid",    maxValue);
        defineObsProperty("currentWinner", "no_winner");
        defineObsProperty("auctionState", "open"); // Novo: nova propriedade observável para estado do leilão
    }

    @OPERATION public void bid(double bidValue) {
        ObsProperty opCurrentValue  = getObsProperty("currentBid");
        ObsProperty opCurrentWinner = getObsProperty("currentWinner");
        ObsProperty opAuctionState = getObsProperty("auctionState");

        if (opAuctionState.stringValue().equals("open")) { // Novo: verifica se o leilão está aberto
            if (bidValue < opCurrentValue.doubleValue()) {  // o lance é melhor que o anterior
                opCurrentValue.updateValue(bidValue);
                opCurrentWinner.updateValue(getCurrentOpAgentId().getAgentName());
            }
        } else { // Novo:
            // Leilão fechado, lance não permitido
            throw new RuntimeException("Auction closed");
        }
    }

    @OPERATION public void clearAuction() { // Novo: Fecha o leilão
        ObsProperty opAuctionState = getObsProperty("auctionState");
        opAuctionState.updateValue("closed");
    }
}

