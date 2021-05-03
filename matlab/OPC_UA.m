function [cart_v_new] = OPC_UA(cart_v, pend_angle)
% Variables
persistent init_Server;
persistent init_Nodes;
persistent uaClient;
persistent Var_Node_cart;
persistent Var_Node_pend;
persistent Var_Node_Out;
persistent val_cart;
persistent val_pend;
persistent output;

%initialize variables
if (isempty(init_Server))
    val_cart = 0;
    val_pend = 0;
    init_Server = 0;
    init_Nodes = 0;
end

%OPC UA connection
if init_Server == 0
    init_Server = 1;
    uaClient = opcua('localhost', 4840);
    setSecurityModel(uaClient, 'Sign');
    connect(uaClient);
end

%define variable nodes in the server
if uaClient.isConnected == 1 && init_Nodes == 0
    init_Nodes = 1;
    %find server namespace
    DB_Node = findNodeByName(uaClient.Namespace, 'PlaceHold', '-once');
    %find variables
    Var_Node_cart = findNodeByName(DB_Node, 'PlaceHold', '-once');
    Var_Node_pend = findNodeByName(DB_Node, 'PlaceHold', '-once');
    %Alternative method if above does not work
    %Var_Node_In = opcuanode(n,n, uaclient);
end  

%Read and write variables of server
if uaClient.isConnected == 1 && init_Nodes == 1
    [val_cart, =, =] = readValue(uaClient, Var_Node_cart);
    [val_pend, =, =] = readValue(uaClient, Var_Node_pend);
    
    %do something with the read values and return the output
    writeValue(uaClient, Var_Node_Out, output);
end