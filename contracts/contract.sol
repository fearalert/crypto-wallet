// SPDX-License-Identifier: MIT 
pragma solidity >=0.8.0 <0.8.24;

contract Wallet {
    address public owner;

    constructor(){
        msg.sender;
    }

    struct request {
        address requester;
        uint256 amount;
        string message;
        string name;
        bool isWithdrawal; // false means deposit, true means withdrawal
    }

    struct sendReceive{
        string action;
        string message;
        uint256 amount;
        address otherPartyAddress;
        string otherPartyName;
    }

    struct userName{
        string name;
        bool hasName;
    }

    mapping(address => userName) names;
    mapping(address => request[]) requests;
    mapping(address => sendReceive[]) history;


    function addName(string memory _name) public{

        userName storage newUserName = names[msg.sender];
        newUserName.name = _name;
        newUserName.hasName = true;
        // require(!names[msg.sender].hasName,"You already have a name!");
        // names[msg.sender] = userName(_name,true);
    }

    function createRequest(address user, uint256 _amount, string memory _message ) public{
        request memory newReq;
        newReq.requester = msg.sender;
        newReq.amount = _amount;
        newReq.message = _message;

        if(names[msg.sender].hasName){
            newReq.name = names[msg.sender].name;
        }

        requests[user].push(newReq);
    }


    function payRequest(uint256 _request) public payable {
        require(_request < requests[msg.sender].length, "No Such Request");
        request[] storage myRequests = requests[msg.sender];
        request storage payableRequest = myRequests[_request];
            
        uint256 toPay = payableRequest.amount * 1 ether;
        require(msg.value == toPay, "Pay Correct Amount");

        payable(payableRequest.requester).transfer(msg.value);

        addHistory(msg.sender, payableRequest.requester, payableRequest.amount, payableRequest.message);

        myRequests[_request] = myRequests[myRequests.length-1];
        myRequests.pop();
    }


    function addHistory(address sender, address receiver, uint256 _amount, string memory _message) private {
            
        sendReceive memory newSend;
        newSend.action = "Send";
        newSend.amount = _amount;
        newSend.message = _message;
        newSend.otherPartyAddress = receiver;
        if(names[receiver].hasName){
            newSend.otherPartyName = names[receiver].name;
        }
        history[sender].push(newSend);

        sendReceive memory newReceive;
        newReceive.action = "Receive";
        newReceive.amount = _amount;
        newReceive.message = _message;
        newReceive.otherPartyAddress = sender;
        if(names[sender].hasName){
            newReceive.otherPartyName = names[sender].name;
        }
        history[receiver].push(newReceive);
    }


//Get all requests sent to a User

function getMyRequests(address _user) public view returns(
         address[] memory, 
         uint256[] memory, 
         string[] memory, 
         string[] memory
){

        address[] memory addrs = new address[](requests[_user].length);
        uint256[] memory amnt = new uint256[](requests[_user].length);
        string[] memory msge = new string[](requests[_user].length);
        string[] memory nme = new string[](requests[_user].length);
        
        for (uint i = 0; i < requests[_user].length; i++) {
            request storage myRequests = requests[_user][i];
            addrs[i] = myRequests.requester;
            amnt[i] = myRequests.amount;
            msge[i] = myRequests.message;
            nme[i] = myRequests.name;
        }
        
        return (addrs, amnt, msge, nme);        
         

}


//Get all historic transactions user has been apartof
    function getMyHistory(address _user) public view returns(sendReceive[] memory){
            return history[_user];
    }

    function getMyName(address _user) public view returns(userName memory){
            return names[_user];
    }

}