// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract Wallet {
  // Layer Lib


  struct AmountMinMax {
    uint256 min;
    uint256 max;
  }
  
  struct Layer {
    AmountMinMax amount;

    uint numTokens;
    mapping (uint => string) tokens;

    // mapping (uint => LayerLib.LayerAPI) layerFlow;
  }

  uint numTransferLayers;
  mapping (uint => mapping (uint => Layer)) TransferLayers;

  struct Transfer {
    uint256 transferNum;
    address receiver;
    uint256 amount;

    uint256 transferLayersIndex;

    bool executed;
  }

  uint numTransfers;
  mapping (uint => Transfer) transfers;

  event LogNumTransferLayers(uint numTransferLayers);
  event LogTransferInQueue(
    uint256 transferNum,
    address receiver,
    uint256 amount,

    uint256 transferLayersIndex,

    bool executed
  );

  function test(address _receiver) public virtual {
    setTransferLayers();

    uint256 amount = 1000;
    makeTransfer(_receiver, amount);

    logTransfers();
  }

  function setTransferLayers() private {
    addTransferLayer();
    addTransferLayer();

    emit LogNumTransferLayers(numTransferLayers);
  }

  // Next: set the transfer layer at index
  // So if we have 8 transfer layers, and want to insert at index 1 then ...

  function addTransferLayer() private {
    uint256 amountMin = 0;
    uint256 amountMax = 100;

    string [] memory tokens = [ "ETH", "USDC" ];

    // Layer memory layer = createTransferLayer();

    numTransferLayers++;
  }

  /*

  function createTransferLayer(
    uint256 _amountMin,
    uint256 _amountMax,
    string [] memory _tokens
  ) private returns (Layer memory) {
    Layer storage layer = TransferLayers[][];

    AmountMinMax memory amount = AmountMinMax({
      min: _amountMin,
      max: _amountMax
    });

    layer.amount = amount;

    layer.tokens[layer.numTokens] = "ETH";

    return layer;
  }

  */

  function makeTransfer(address _receiver, uint256 _amount) private {
    Transfer memory transfer = Transfer({
      transferNum: numTransfers,
      receiver: _receiver,
      amount: _amount,

      transferLayersIndex: numTransfers,

      executed: false
    });

    transfers[numTransfers] = transfer;

    numTransfers++;
  }
  
  function logTransfers() private {
    for (uint256 i = 0; i < numTransfers; i++) {
      Transfer memory transfer = transfers[i];

      uint256 transferNum = transfer.transferNum;
      address receiver = transfer.receiver;
      uint256 amount = transfer.amount;

      uint256 transferLayersIndex = transfer.transferLayersIndex;

      bool executed = transfer.executed;

      emit LogTransferInQueue(
        transferNum,
        receiver,
        amount,

        transferLayersIndex,

        executed
      );

      // Layers.
      // transferNum => 0 => Layer
      // How we get 0,1,2,3...
      // numLayers in Transfer struct
      // we always have the same number of layers for each transfer
      // so we have 1 variable that keeps track of num layers
      // not in transfer
    }
  }
}
