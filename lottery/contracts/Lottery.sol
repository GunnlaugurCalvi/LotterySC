pragma solidity ^0.4.17;

contract Lottery {
    
    address public manager;
    address[] public players;
    address public lastWinner;
    
    constructor() public {
        manager = msg.sender;    
    }
    
    function enter() public payable {
        require(msg.value > .01 ether);//Global variable: is used for validation, boolean function, 
                                       //if it returns false it is immediatly canceled
        players.push(msg.sender); 
    }
    //pseudo random
    function random() private view returns(uint) {
        return uint(keccak256(block.difficulty, now, players)); //Sha3(), keccak256() are the same thing and are global variables
                                              // block is also global variable also variable now to get an alias for block.timestamp
    }   
    function pickWinner() public restricted {
        // require(msg.sender == manager); //only the manager can use this function
        
        uint index = random() % players.length;
        players[index].transfer(address(this).balance);
        lastWinner = players[index];
        players = new address[](0); //creates brand new dynamic array of addresses
                                    //to reset the lottery after picking a winner
    }

    function getPlayers() public view returns(address[]){
        return players;    
    }   
    
    //extra function
    function prizePool() public view returns(uint) {
       return uint(address(this).balance);
    }
    


    modifier restricted() { //are used soley to reducing amount of code to write. Basicly used 
                            //to not repeat ourselv
        require(msg.sender == manager);
        _; //This underscore will be replaced for the code in the function that is decorated with our modifier name
           //pretty fucking smart 
    }
    
    
}   