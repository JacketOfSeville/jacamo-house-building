package tools;

import cartago.Artifact;
import cartago.OPERATION;
import cartago.ObsProperty;

public class EnglishAuctionArt extends Artifact {

    @OPERATION public void init(String taskDs, int maxValue) {
        // Propriedades observaveis
        defineObsProperty("task", taskDs);
        defineObsProperty("maxValue", maxValue);
        defineObsProperty("currentPrice", 0);
        defineObsProperty("winner", "no_winner");
        defineObsProperty("auctionState", "open");
    }

    @OPERATION public void bid(String agentId) {
        ObsProperty opCurrentPrice = getObsProperty("currentPrice");
        ObsProperty opAuctionState = getObsProperty("auctionState");

        if (opAuctionState.stringValue().equals("open")) {
            int newPrice = opCurrentPrice.intValue() + 1;
            opCurrentPrice.updateValue(newPrice);
        } else {
            throw new RuntimeException("Auction closed");
        }
    }

    @OPERATION public void accept(String agentId) {
        ObsProperty opWinner = getObsProperty("winner");
        ObsProperty opAuctionState = getObsProperty("auctionState");

        if (opAuctionState.stringValue().equals("open")) {
            opWinner.updateValue(agentId);
            opAuctionState.updateValue("closed");
        } else {
            throw new RuntimeException("Auction already closed");
        }
    }
}