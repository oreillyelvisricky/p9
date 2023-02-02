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
  event LogTransferLayer(
    uint numTransferLayers,
    uint numTransfers,

    uint256 amountMin,
    uint256 amountMax
  );
  event LogTransferInQueue(
    uint numTransferLayers,

    uint256 transferNum,
    address receiver,
    uint256 amount,

    uint256 transferLayersIndex,

    bool executed
  );

  function test(address _receiver) public virtual {
    testSetTransferLayers();
    testLogTransferLayers();

    // uint256 amount = 1000;
    // makeTransfer(_receiver, amount);

    logTransfers();
  }

  function testSetTransferLayers() private {
    createTransferLayer(0, 0, 0, 100);
    createTransferLayer(0, 1, 100, 200);

    emit LogNumTransferLayers(numTransferLayers);
  }

  function createTransferLayer(
    uint256 _transferNum,
    uint256 _transferLayerNum,

    uint256 _amountMin,
    uint256 _amountMax
  ) private {
    // if adding a layer lock the transfers
    // no new transfer can be made but we can queue it until this is done then make it
    // 
    // what about adding/removing/updating layers
    // 

    // Or get numTransfers and loop
    // What is a new transfer gets added whilst this is happening
    // lock
    // always need to lock either way
    // Tmp TransferLayer
    // Then set it in TransferLayers diff function for
    Layer storage layer = TransferLayers[_transferNum][_transferLayerNum];

    AmountMinMax memory amount = AmountMinMax({
      min: _amountMin,
      max: _amountMax
    });

    layer.amount = amount;

    string [2] memory _tokens = [ "ETH", "USDC" ];

    for (uint i = 0; i < _tokens.length; i++) {
      string memory token = _tokens[i];

      layer.tokens[i] = token;

      layer.numTokens++;
    }

    // If transfer layers are already set
    // If there are already transfers
    // We need to overwrite transferLayers
    // Because they need to be in sequence

    numTransferLayers++;
  }

  function wtfsetTransferLayers() private {
    // set here include tmp
  }

  function wtflogTransferLayers() private {
    // numTransferLayers is the total number of TransferLayers
    // That's for every transfer
    // So if there's 3 layers per transfer
    // And there's 100 transfers
    // Then 300 transfer layers
    // need a variable that keeps track of num transfer layers per transfer
    // numTransferLayers = num per EACH transfer which is fixed
    // totalNumTransferLayers = numTransferLayers * numTransfers
    /*
    for (uint i = 0; i < totalNumTransferLayers; i++) {
      //
    }
    */
  }

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




  function testLogTransferLayers() private {
    // numTransferLayers is the total number of TransferLayers
    // That's for every transfer
    // So if there's 3 layers per transfer
    // And there's 100 transfers
    // Then 300 transfer layers
    // need a variable that keeps track of num transfer layers per transfer
    // numTransferLayers = num per EACH transfer which is fixed
    // totalNumTransferLayers = numTransferLayers * numTransfers
    // mapping (uint => mapping (uint => Layer)) TransferLayers;
    for (uint i = 0; i < numTransferLayers; i++) {
      Layer storage layer = TransferLayers[0][i];

      uint256 amountMin = layer.amount.min;
      uint256 amountMax = layer.amount.max;

      emit LogTransferLayer(
        numTransferLayers,
        numTransfers,

        amountMin,
        amountMax
      );
    }
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
        numTransferLayers,

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
