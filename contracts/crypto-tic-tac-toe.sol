pragma solidity ^0.8.4;

contract CryptoTicTacToe{
    
    // Structs
    struct WinningCase{
        uint256 firstIndex;
        uint256 secondIndex;
        uint256 thirdIndex;
    }
    
    // Public Game State Variables
    bool public isGameFinished;
    address public playerO;
    address public playerX;
    address public currentPlayer;
    address public gameOwner;
    address public lastWinner;
    
    // Private Game State Varibales
    int8 private emptySpace = -1;
    int8 private moveO = 0;
    int8 private moveX = 1;
    int8[9] private emptyBoard = [-1, -1, -1, -1, -1, -1, -1, -1, -1];
    int8[9] private gameBoard = int8[9](emptyBoard);
    WinningCase[] private winningCases;
    WinningCase private winnerCase;
    
    // Constructor
    constructor (address _playerO, address _playerX) public {
        // Initialize game variables
        gameOwner = msg.sender;
        playerO = _playerO;
        playerX = _playerX;
        currentPlayer = playerO;
        createWinningCases();
    }
        
    // Show actual board state
    function getBoard() public view returns (int8[9] memory) {
        return gameBoard;
    }
    
    // Create and add winning cases
    function createWinningCases() private {
        WinningCase memory case1 = WinningCase(0, 1, 2);
        WinningCase memory case2 = WinningCase(3, 4, 5);
        WinningCase memory case3 = WinningCase(6, 7, 8);
        WinningCase memory case4 = WinningCase(0, 3, 6);
        WinningCase memory case5 = WinningCase(1, 4, 7);
        WinningCase memory case6 = WinningCase(2, 5, 8);
        WinningCase memory case7 = WinningCase(0, 4, 8);
        WinningCase memory case8 = WinningCase(2, 4, 6);
        winningCases.push(case1);
        winningCases.push(case2);
        winningCases.push(case3);
        winningCases.push(case4);
        winningCases.push(case5);
        winningCases.push(case6);
        winningCases.push(case7);
        winningCases.push(case8);
    }
    
    // Attempt to make a move
    function makeMove (uint8 _index) public {
        require ((_index >= 0 && _index <= 9 && msg.sender == currentPlayer && gameBoard[_index] == emptySpace && !isGameFinished), "Error: Cannot place a move. Make sure the input is valid.");
        gameBoard[_index] = (currentPlayer == playerO ? moveO : moveX);
        currentPlayer = (currentPlayer == playerO ? playerX : playerO);

        if (isBoardFull()){
            isGameFinished = true;
        }
        else if (hasWinner()){
            isGameFinished = true;
            lastWinner = getWinnerAddress();
        }
    }
    
    // Check for a win
    function hasWinner() private returns (bool) {
        for (uint i = 0; i < winningCases.length; i++) {
            WinningCase memory currentCase = winningCases[i];
            uint256 firstIndex = currentCase.firstIndex; uint256 secondIndex = currentCase.secondIndex; uint256 thirdIndex = currentCase.thirdIndex;
            if (gameBoard[firstIndex] == gameBoard[secondIndex] && gameBoard[secondIndex] == gameBoard[thirdIndex] && gameBoard[firstIndex] != emptySpace){
                winnerCase = currentCase;
                return true;
            }
        }
        
        return false;
    }
    
    // Get winner address
    function getWinnerAddress() private view returns (address winner) {
        return winnerCase.firstIndex == 0 ? playerO : playerX;
    }
    
    // Attempt to change players
    function changePlayers(address _playerO, address _playerX) public {
        require (msg.sender == gameOwner, "Error: Only gameOwner can call changePlayers function");
        playerO = _playerO;
        playerX = _playerX;
    }
    
    // Attempt to change ownership
    function changeOwner(address _newOwner) public {
        require (msg.sender == gameOwner, "Error: Only gameOwner can call changeOwner function.");
        gameOwner = _newOwner;
    }
    
    // Helper methods
    function isBoardFull() private view returns (bool) {
        for (uint i = 0; i < gameBoard.length ; i++){
            if (gameBoard[i] == -1){
                return false;
            }
        }
        return true;
    }
}