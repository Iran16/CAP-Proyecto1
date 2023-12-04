const cds = require("@sap/cds");
const { rejects } = require("assert");
const { Orders } = cds.entities("com.training");

module.exports = (srv) => {
    /////************READ*************/
    srv.on("READ", "GetOrders", async (req) => {

        if (req.data.ClientEmail !== undefined) {
            return await SELECT.from`com.training.Orders`.where`ClientEmail = ${req.data.ClientEmail}`;
        }
        return await SELECT.from(Orders);
    });

    srv.after("READ", "GetOrders", (data) => {
        data.map((order2) => {
            order2.Reviewed = true

        });
        return data;

    });

    /////************Create *************/
    srv.on("CREATE", "CreateOrder", async (req) => {

        let returnData = await cds.transaction(req)
            .run(
                INSERT.into(Orders).entries({
                    ClientEmail: req.data.ClientEmail,
                    FirstName: req.data.FirstName,
                    LastName: req.data.LastName,
                    CreateOn: req.data.CreateOn,
                    Reviewed: req.data.Reviewed,
                    Approved: req.data.Approved
                })

            ).then((resolve, reject) => {
                console.log("Resolve", resolve);
                console.log("Reject", reject);

                if (typeof resolve !== "undefined") {
                    return req.data;
                } else {
                    req.error(409, "Record not Inserted");
                }
            }).catch((err) => {
                console.log(err);
                req.error(err.code, err.message);
            });
        return returnData;
    });
    /////************Update *************/
    srv.on("UPDATE", "UpdateOrder", async (req) => {

        let returnData = await cds.transaction(req).run(
            [
                UPDATE(Orders, req.data.ClientEmail).set({
                    FirstName: req.data.FirstName,
                    LastName: req.data.LastName
                })
            ]
        ).then((resolve, reject) => {
            console.log("Resolve", resolve);
            console.log("Reject", reject);
            if (resolve[0] == 0) {
                req.error(409, "Record Not Found");
            }
        }).catch((err) => {
            console.log(err);
            req.error(err.code, err.message);
        });
        console.log("Before End", returnData);
        return returnData;
    });


    /////************Delete *************/
    let returnData = srv.on("DELETE", "DeleteOrder", async (req) => {
        cds.transaction(req).run(
            DELETE.from(Orders,).where({
                ClientEmail: req.data.ClientEmail
            })

        ).then((resolve, reject) => {
            console.log("Resolve", resolve);
            console.log("Reject", reject);

            if (resolve !== 1) {

                req.error(409, "Record not Found");
            }
        }).catch((err) => {
            console.log(err);
            req.error(err.code, err.message);
        });
        console.log("Before End", returnData);
        return await returnData;

    });
    /////************Function *************/
    srv.on("getClientTaxRate", async (req) => {
        // NO server side-effect
        const { VclientEmail } = req.data;
        const db = srv.transaction(req);

        const results = await db.read(Orders, ["Country_code"]).where({ ClientEmail: VclientEmail });

        console.log(results[0]);

        switch (results[0].Country_code) {
            case 'ES':
                return 21.5;
            case 'UK':
                return 24.6;
            default:
                break;
        }

    });
    /////************Action *************/
    srv.on("cancelOrder", async (req) => {
        const { VclientEmail } = req.data;
        const db = srv.transaction(req);

        const resultsRead = await db
            .read(Orders, ["FirstName", "LastName", "Approved"])
            .where({ ClientEmail: VclientEmail })

        let rturnOrder = {
            status: "",
            message: ""
        };

        console.log(VclientEmail);
        console.log(resultsRead);

        if (resultsRead[0].Approved == false) {
            const resultUpdate = await db
                .update(Orders)
                .set({ Status: "C" })
                .where({ ClientEmail: VclientEmail });
            rturnOrder.status = "Succes";
            rturnOrder.message = `The Order Place by ${resultsRead[0].FirstName} ${resultsRead[0].LastName} was cancel`;
        } else {
            rturnOrder.status = "Failed";
            rturnOrder.message = `The Order Place by ${resultsRead[0].FirstName} ${resultsRead[0].LastName} was NOT cancel`;

        };
        console.log("Action cancelOrder Execute");
        return rturnOrder;


    });
}

