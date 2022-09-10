// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Event {
    // Eventos de creación de nuevo evento y alerta
    event newEventCreated(string _event);
    event newAlertCreated(address node, string message, Risk risk);

    // Estructura de las alertas
    struct Alert {
        string message;
        Risk risk;
        address node;
    }

    // Nivel de riesgo de una alerta
    enum Risk {
        HIGH,
        MEDIUM,
        LOW
    }

    // Array de alertas importantes
    Alert[] public alerts;

    // Mapping de eventos por cuenta
    mapping(address => mapping(uint256 => string)) public events;

    // Mapping para llevar un control de la cantidad de eventos por cuenta
    mapping(address => uint256) public eventsCounter;

    // Límite de eventos por cuenta y owner del contrato
    uint256 public threshold;
    address private owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can execute this function");
        _;
    }

    constructor(uint256 _threshold) {
        threshold = _threshold;
        owner = msg.sender;
    }

    // Incrementar o decrementar el límite de eventos a guardar por cuenta
    function setThreshold(uint256 _threshold) public onlyOwner {
        threshold = _threshold;
    }

    // Crear nuevo evento
    function createEvent(string memory _event) public returns (bool success) {
        uint256 eventId = eventsCounter[msg.sender] + 1;
        if (eventId > threshold) {
            eventId = 1;
        }
        eventsCounter[msg.sender] = eventId;
        events[msg.sender][eventId] = _event;
        emit newEventCreated(_event);
        success = true;
    }

    // Crear nueva alerta importante
    function createAlert(Risk risk, string memory message)
        public
        returns (bool success)
    {
        alerts.push(Alert(message, risk, msg.sender));
        emit newAlertCreated(msg.sender, message, risk);
        success = true;
    }
}
