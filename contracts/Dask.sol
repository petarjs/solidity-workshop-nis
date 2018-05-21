pragma solidity ^0.4.18;

contract Dask {
    address owner;

    uint PRICE_PER_ANSWER = 10000;

    struct Question {
        string text;
        uint maxAnswers;
        uint currentAnswers;
        uint pool;
        mapping (address => uint) answers;
    }

    mapping (address => mapping (string => Question)) questions;

    event PricePerAnswerSet(uint price);
    event QuestionAsked(address askedBy, string text);
    event QuestionAnswered(address askedBy, string text, uint answer);

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function setPricePerAnswer(uint price) public onlyOwner {
        PRICE_PER_ANSWER = price;
        emit PricePerAnswerSet(price);
    }

    function getPricePerAnswer() public view returns(uint) {
        return PRICE_PER_ANSWER;
    }

    function askQuestion(string text, uint maxAnswers) public payable {
        require(msg.value == maxAnswers * PRICE_PER_ANSWER);
        questions[msg.sender][text] = Question(text, maxAnswers, 0, msg.value);
        emit QuestionAsked(msg.sender, text);
    }

    function answerQuestion(address askedBy, string text, uint answer) public {
        Question memory question = questions[askedBy][text];
        
        require(answer > 0 && answer < 6);
        require(questions[askedBy][text].answers[msg.sender] == 0);
        require(question.currentAnswers <= question.maxAnswers);

        questions[askedBy][text].answers[msg.sender] = answer;

        msg.sender.transfer(PRICE_PER_ANSWER);
        questions[askedBy][text].pool -= PRICE_PER_ANSWER;
        questions[askedBy][text].currentAnswers += 1;

        emit QuestionAnswered(askedBy, text, answer);
    }
}