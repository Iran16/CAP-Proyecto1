namespace com.ih;

// type Gender : String enum {
//     male;
//     famale;
// };

// entity Order {
//     clientGener : Gender;
//     status      : Integer enum {
//         submitted = 1;
//         fulfiller = 2;
//         shipped   = 3;
//         cancel    = -1;
//     };
//     priority    : String @assert.range enum {
//         hihg;
//         mediun;
//         low;

//     }

// };

type Address {
    Street     : String;
    City       : String;
    State      : String(2);
    PostalCode : String(5);
    Country    : String(3);
};

context materials {


    entity Products {
        key ID                : String;
            Name              : String not null;
            Description       : String;
            ImageUrl          : String;
            ReleaseDate       : DateTime default $now;
            DiscontinuedDate  : DateTime;
            Price             : Decimal(16, 2);
            Height            : Decimal(16, 2);
            Width             : Decimal(16, 2);
            Depth             : Decimal(16, 2);
            Quantity          : Decimal(16, 2);
            Suppliers         : Association to one sales.Suppliers;
            UnitOfMeasures    : Association to one UnitOfMeasures;
            Currency          : Association to Currencies;
            DimensionsUnit    : Association to DimensionsUnits;
            Category          : Association to Categories;
            SalesDate         : Association to many SalesData
                                    on SalesDate.Product = $self;
            Reviews           : Association to many ProductReview
                                    on Reviews.Product = $self;


    };

    entity Categories {
        key ID   : String(1);
            Name : String;

    };

    entity StockAvailability {
        key ID          : Integer;
            Description : String;

    };

    entity Currencies {
        key ID          : String(3);
            Description : String;
    };

    entity UnitOfMeasures {
        key ID          : String(2);
            Description : String;
    };

    entity DimensionsUnits {
        key ID          : String(2);
            Description : String;
    };


};

context sales {
    entity Suppliers {
        key ID         : UUID;
            Name       : String;
            Street     : String;
            City       : String;
            State      : String(2);
            PostalCode : String(5);
            Country    : String(3);
            Email      : String;
            Phone      : String;
            Fax        : String;
            Product    : Association to many materials.Products
                             on Product.Suppliers = $self;

    };


    entity Months {
        key ID               : String(2);
            Description      : String;
            ShortDescription : String(3);
    };

}


entity ProductReview {
    key ID      : UUID;
        Name    : String;
        Rating  : Integer;
        Comment : String;
        Product : Association to materials.Products;

};


entity SalesData {
    key Id            : UUID;
        DeliveryDate  : DateTime;
        Revenue       : Decimal(16, 2);
        Product       : Association to materials.Products;
        currency      : Association to materials.Currencies;
        DeliveryMonth : Association to sales.Months;

};

entity SelProducts3 as
    select from materials.Products
    left join ProductReview
        on Products.Name = ProductReview.Name
    {
        Rating,
        Products.Name,
        sum(Price) as totalPrice

    }
    group by
        Rating,
        Products.Name
    order by
        Rating;

extend materials.Products with {
    PriceCondition     : String(2);
    PriceDetermination : String(3);

};

context reports {

    entity AverageRating 
     as select from  ProductReview{
        Product.ID as ProductId,
        avg (Rating)  as AverageRating: Decimal(16,2)
     }group by Product.ID;

     entity Products as
        select from materials.Products
        mixin{
            ToStockAvailibity : Association to materials.StockAvailability
                                on ToStockAvailibity.ID = $projection.StockAvailability;
            ToAverageRating : Association to AverageRating
                                on ToAverageRating.ProductId = ID;

        }
        into {
            *,
            ToAverageRating.AverageRating as Rating,
            case
             when Quantity >= 8 then 3
             when Quantity > 0 then 2
             else 1
             end as StockAvailability : Integer,
             ToStockAvailibity


        }
        
     
    
};
