using CatalogService2 as service from '../../srv/catalog-service';

annotate service.Products with @(
    Capabilities: { DeleteRestrictions : {
        $Type : 'Capabilities.DeleteRestrictionsType',
        Deletable: false
    }, },

    UI.HeaderInfo     : {
        TypeName      : 'Product',
        TypeNamePlural: 'Products',
        ImageUrl      : ImageUrl,
        Title         : {Value: Name},
        Description   : {Value: Description}
    },

    UI.SelectionFields: [
        ToCurrency_ID,
        ToCategory_ID,
        StockAvailability

    ],
    UI.LineItem       : [
        {
            $Type: 'UI.DataField',
            Label: 'ImageUrl',
            Value: ImageUrl,
        },
        {
            $Type: 'UI.DataField',
            Label: 'ProductName',
            Value: Name,
        },

        {
            $Type: 'UI.DataField',
            Label: 'ID',
            Value: ID,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Description',
            Value: Description,
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Label : 'Supplier',
            Target: 'Suppliers/@Communication.Contact'

        },
        {
            $Type: 'UI.DataField',
            Label: 'ReleaseDate',
            Value: ReleaseDate,
        },
        {
            Label      : 'Stock Availability',
            Value      : StockAvailability,
            Criticality: StockAvailability
        },
        {
            // $Type : 'UI.DataField',
            Label : 'Rating',
            // Value : Rating,
            $Type : 'UI.DataFieldForAnnotation',
            Target: '@UI.DataPoint#AverageRating'
        },
        {
            $Type: 'UI.DataField',
            Label: 'Price',
            Value: Price,
        },
    ]
);

annotate service.Products with {
    Suppliers @Common.ValueList: {
        $Type         : 'Common.ValueListType',
        CollectionPath: 'Suppliers',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: Suppliers_ID,
                ValueListProperty: 'ID',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Name',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Email',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Phone',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Fax',
            },
        ],
    }
};

annotate service.Products with @(
    UI.FieldGroup #GeneratedGroup1: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'ID',
                Value: ID,
            },
            // {
            //     $Type: 'UI.DataField',
            //     Label: 'Name',
            //     Value: Name,
            // },
            // {
            //     $Type: 'UI.DataField',
            //     Label: 'Description',
            //     Value: Description,
            // },
            // {
            //     $Type: 'UI.DataField',
            //     Label: 'ImageUrl',
            //     Value: ImageUrl,
            // },
            {
                $Type: 'UI.DataField',
                Label: 'ReleaseDate',
                Value: ReleaseDate,
            },
            {
                $Type: 'UI.DataField',
                Label: 'DiscontinuedDate',
                Value: DiscontinuedDate,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Price',
                Value: Price,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Height',
                Value: Height,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Width',
                Value: Width,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Depth',
                Value: Depth,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Quantity',
                Value: Quantity,
            },
            {
                $Type: 'UI.DataField',
                Label: 'ToUnitOfMeasures_ID',
                Value: ToUnitOfMeasures_ID,
            },
            {
                $Type: 'UI.DataField',
                Label: 'ToCurrency_ID',
                Value: ToCurrency_ID,
            },
            {
                $Type: 'UI.DataField',
                Label: 'ToCategory_ID',
                Value: ToCategory_ID,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Category',
                Value: Category,
            }

        ]
    },
    UI.FieldGroup #GeneratedGroup2: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'ToDimensionUnit_ID',
                Value: ToDimensionUnit_ID,
            },
            {
                //$Type: 'UI.DataField',
                Label : 'Rating',
                $Type : 'UI.DataFieldForAnnotation',
                Target: '@UI.DataPoint#AverageRating',
            //Value: Rating,
            },
            {

                Label      : 'StockAvailability',
                Value      : StockAvailability,
                Criticality: StockAvailability
            }
        ]

    },

    UI.Facets                     : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneratedFacet1',
            Label : 'General Information',
            Target: '@UI.FieldGroup#GeneratedGroup1',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneratedFacet2',
            Label : 'General Information 2',
            Target: '@UI.FieldGroup#GeneratedGroup2',
        }

    ],
    UI.HeaderFacets: [{
        $Type: 'UI.ReferenceFacet',
        Target: '@UI.DataPoint#AverageRating'
    }]
);
/*
    Annotation for SH
*/

annotate service.Products with {
    // Category
    ToCategory @(Common: {
        Text     : {
            $value                : Category,
            ![@UI.TextArrangement]: #TextOnly
        },
        ValueList: {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'VH_categories',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: ToCategory_ID,
                    ValueListProperty: 'Code'
                },
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: Category,
                    ValueListProperty: 'Text'
                }
            ]
        },

    });

    //Currency
    ToCurrency @(Common: {
        ValueListWithFixedValues: true,
        ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'VH_Curremcies',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: ToCurrency_ID,
                    ValueListProperty: 'Code'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'Text'
                }
            ]
        },
    })

};

annotate service.Products with {
    ImageUrl @(UI.IsImageURL: true)
};


/*
    Annotation for VH_Categories Entity
*/
annotate service.VH_categories with {

    Code @(
        UI    : {Hidden: true},
        Common: {Text: {
            $value                : Text,
            ![@UI.TextArrangement]: #TextOnly,
        }, }
    );
    Text @(UI: {HiddenFilter: true});
};

/*
    Annotation for VH_Currency Entity
*/
annotate service.VH_Curremcies with {
    Code @(UI: {HiddenFilter: true});
    Text @(UI: {HiddenFilter: true});


};
/**
 * Annotacion for Supplier entitu
 */

annotate service.Suppliers with @(Communication: {Contact: {
    $Type: 'Communication.ContactType',
    fn   : Name,
    role : 'Supplier - Role',
    photo: 'sap-icon://supplier',
    email: [{
        type   : #work,
        address: Email,

    }],
    tel  : [
        {
            type: #work,
            uri : Phone
        },
        {
            type: #fax,
            uri : Fax
        }
    ]
}

});

/**
 * Data Ponit for average Reating
 */

annotate service.Products with @(UI.DataPoint #AverageRating: {
    Value        : Rating,
    Title        : 'Rating',
    TargetValue  : 40,
    Visualization: #Progress
});
