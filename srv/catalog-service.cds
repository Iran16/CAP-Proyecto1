using {com.ih as loga} from '../db/schema';

service CatalogServices {
    entity Products          as projection on loga.materials.Products;
    entity Suppliers         as projection on loga.sales.Suppliers;
    entity UnitOfMeasuresSrv as projection on loga.materials.UnitOfMeasures;
    entity Currency          as projection on loga.materials.Currencies;
    entity DimensionsUnit    as projection on loga.materials.DimensionsUnits;
    entity Category          as projection on loga.materials.Categories;
    entity SalesDate         as projection on loga.SalesData;
    entity Reviews           as projection on loga.ProductReview;


};

define service CatalogService2 {
    entity Products          as
        select from loga.reports.Products {
            ID,
            Name                               @mandatory,
            Description                        @mandatory,
            ImageUrl,
            ReleaseDate,
            DiscontinuedDate,
            Price                              @mandatory,
            Height,
            Width,
            Depth,
            Quantity                           @(
                mandatory,
                assert.range: [
                    0.00,
                    20.000
                ]
            ),
            UnitOfMeasures as ToUnitOfMeasures @mandatory,
            Currency       as ToCurrency       @mandatory,
            Category       as ToCategory       @mandatory,
            Category.Name  as Category         @readonly,
            DimensionsUnit as ToDimensionUnit,
            SalesDate,
            Suppliers,
            Reviews, 
            Rating,
            StockAvailability,
            ToStockAvailibity


        };

    @readonly
    entity Suppliers         as
        select from loga.sales.Suppliers {
            ID,
            Name,
            Email,
            Phone,
            Fax,
            Product as ToProduct

        };

    entity Reviews           as
        select from loga.ProductReview {
            ID,
            Name,
            Rating,
            Comment,
            Product as ToProduct

        };

    @readonly
    entity VH_categories     as
        select from loga.materials.Categories {
            ID   as Code,
            Name as Text
        };

    @readonly
    entity VH_Curremcies     as
        select from loga.materials.Currencies {
            ID          as Code,
            Description as Text
        };

    @readonly
    entity VH_UnitOfMesaure  as
        select from loga.materials.UnitOfMeasures {
            ID          as Code,
            Description as Text
        };

    @readonly
    entity VH_DimensionUnits as
        select
            ID          as Code,
            Description as Text

        from loga.materials.DimensionsUnits;

};

define service Reports {
    entity AverageRating     as projection on loga.reports.AverageRating;


}
