package tools;

import cartago.Artifact;
import cartago.OPERATION;
import cartago.ObsProperty;

/**
 *      Artefato que implementa o leilão.
 */
public class AuctionArt extends Artifact {

    @OPERATION public void init(String taskDs, int maxValue, int biddingTime)  {
        // Propriedades observaveis
        defineObsProperty("task",          taskDs);
        defineObsProperty("maxValue",      maxValue);
        defineObsProperty("currentBid",    maxValue);
        defineObsProperty("currentWinner", "no_winner");
        defineObsProperty("auctionState", "open"); // Novo: nova propriedade observável para estado do leilão
        defineObsProperty("biddingTime", biddingTime); // Novo: propriedade observável para prazo de lance
    }

    @OPERATION public void startAuction() {
        ObsProperty opAuctionState = getObsProperty("auctionState");
        opAuctionState.updateValue("open");
    }

    @OPERATION public void bid(double bidValue) {
        ObsProperty opCurrentValue  = getObsProperty("currentBid");
        ObsProperty opCurrentWinner = getObsProperty("currentWinner");
        ObsProperty opAuctionState = getObsProperty("auctionState");
        ObsProperty opBiddingTime = getObsProperty("biddingTime");

        if (opAuctionState.stringValue().equals("open")) { // Verifica se o leilão está aberto
            if (bidValue < opCurrentValue.doubleValue()) {  // o lance é melhor que o anterior
                opCurrentValue.updateValue(bidValue);
                opCurrentWinner.updateValue(getCurrentOpAgentId().getAgentName());
            }
        } else { // Leilão fechado, lance não permitido
            throw new RuntimeException("Auction closed");
        }

        // Verifica se o prazo de lance expirou
        if (opBiddingTime.intValue() <= 0) {
            opAuctionState.updateValue("closed");
        } else {
            opBiddingTime.updateValue(opBiddingTime.intValue() - 1);
        }
    }
}