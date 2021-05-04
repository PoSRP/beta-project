function [setCartVelocity] = OPC_UA(cartPosition, cartVelocity, pendulumAngle) 
% Variables 
persistent init_Server; 
persistent init_Nodes; 
persistent uaClient; 
persistent values;
persistent outputNode; 
cartPosition = 0;
cartVelocity = 0; 
pendulumAngle = 0;
setCartVelocity= 0;

 
%initialize variables 
if (isempty(init_Server)) 
    init_Server = 0; 
    init_Nodes = 0; 
end 
 
%OPC UA connection 
if init_Server == 0 
    init_Server = 1; 
    uaClient = opcua('localhost', 4840); 
    setSecurityModel(uaClient, 'None'); 
    connect(uaClient); 
end 
 
%define variable nodes in the server 
if uaClient.isConnected == 1 && init_Nodes == 0 
    init_Nodes = 1;
    %find server namespace 
    top = uaClient.Namespace;
    server = top(5).Children;
    modules = server(2).Children;
    program = modules(1).Children;
    opcUa = program(1).Children;
    values = opcUa(1).Children;
    outputNode = values(3);
end   
 
%Read and write variables of server 
if uaClient.isConnected == 1 && init_Nodes == 1 
    cartPosition = readValue(values(1));
    cartVelocity = readValue(values(2));
    pendulumAngle = readValue(values(3));
    setCartVelocity = readValue(values(4));
     
    %do something with the read values and return the output 
    writeValue(uaClient, outputNode, 1);
end