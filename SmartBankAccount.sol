pragma solidity >=0.7.0 <0.9.0;

contract SmartBankAccount {
    uint totalContractBalance = 0;
    
    function getContractBalance() public view returns(uint) {
        return totalContractBalance;
    }
    
    mapping (address => uint) balances;
    mapping (address => uint) depositTimestamps;
    
    function addBalance() public payable {
        // msg.sender is the addrss of the person who sent the message
        // msg.value is the money being sent
        balances[msg.sender] = msg.value; 
        totalContractBalance = totalContractBalance + msg.value;
        depositTimestamps[msg.sender] = block.timestamp;
    }
    
    function getBalance(address _userAddress) public view returns(uint) {
        uint principal = balances[_userAddress]; // Users account balance
        uint timeElapsed = block.timestamp - depositTimestamps[_userAddress]; // How long in seconds its been since balance added
        return principal + uint((principal * 7 * timeElapsed) / (100 * 365 * 24 * 60 * 60)) + 1; // Interest of 0.07% per year
    }
    
    
    function withdraw() public payable {
        address payable withdrawTo = payable(msg.sender);
        uint amountToTransfer = getBalance(msg.sender); // Get the users balance
        withdrawTo.transfer(amountToTransfer); // Send the user their balance
        totalContractBalance = totalContractBalance - amountToTransfer;
        balances[msg.sender] = 0;
    }
    
    function addMoneyToContract() public payable {
        totalContractBalance = totalContractBalance + msg.value;
    }
    
    
    
    
}