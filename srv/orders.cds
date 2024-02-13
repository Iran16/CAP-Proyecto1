using com.training as training from '../db/training';

service ManageOrders {
    type cancelOrderReturn {
        status  : String enum {
            Succes;
            Failed
        };
        message : String
    };

    // entity GetOrders   as projection on training.Orders;
    entity CreateOrder as projection on training.Orders;
    entity UpdateOrder as projection on training.Orders;
    entity DeleteOrder as projection on training.Orders;

    //  function getClientTaxRate(VclientEmail : String(65)) returns Decimal(4, 2);
    //  action   cancelOrder(VclientEmail : String(65)) returns cancelOrderReturn;

     entity GetOrders   as projection on training.Orders
     actions {
         function getClientTaxRate(VclientEmail : String(65)) returns Decimal(4, 2);
          action   cancelOrder(VclientEmail : String(65)) returns cancelOrderReturn;

     }
    
}
