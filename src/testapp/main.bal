import ballerina/io;
import ballerina/http;

http:Client hc = new ("http://localhost:9090");

public function main() returns error? {
    http:Response hr;
    json jr;

    string i1uuid = check post ("/institution", {
        "name": "Dehiwala MC", 
        "address": { "line1": "99 MC Road", "line2": "Dehiwala"}, 
        "phone": "011-273-3333", 
        "fax": "011-273-4444", 
        "divisionalSecretariat": "Dehiwala Mt Lavinia" });
    io:println ("Added institution 'Dehiwala MC': " + i1uuid);
    string i2uuid = check post ("/institution", {
        "name": "Matara Central College", 
        "address": { "line1": "58 Central College Road", "line2": "Matara"}, 
        "phone": "041-333-3333", 
        "fax": "041-444-4444", 
        "divisionalSecretariat": "Matara Thotamuna" });
    io:println ("Added institution 'Matara Central College': " + i2uuid);

    Institution i = {
        name: "Rahula Vidyalaya",
        address: {
            line1: "1 Rahula Road",
            line2: "Matara"
        },
        phone: "041-451-8888",
        fax: "041-451-8887",
        divisionalSecretariat: "Matara South"
    };
    string i3uuid = check post ("/institution", check json.constructFrom (i));
    io:println ("Added institution '" + i.name + "': " + i3uuid);

    // add an officer to i1uuid
    Officer o = {
        idNumber: "6303651235v",
        nameWithInitials: "B. S. Podisingho",
        dob: {
            year: 1963,
            month: 12,
            day: 31
        },
        gender: <Gender> "F",
        address: { 
            line1: "19 Boru Para",
            line2: "Wattala"
        },
        mobilePhone: "077-777-6631",
        homePhone: "008-613-1361",
        email: "podisngiht@koskatta.lk",
        emergencyContact: {
            name: "X. DeadMan",
            phone: "033-901-6141"
        },
        pollingStationId: "AB-136",
        preferredDistrictIds: ["Matara", "Colombo", "Chilaw", "Jaffna", "Gampaha"],
        position: {
            instituteUuid: i1uuid,
            post: "Technical Officer Grade I",
            postNature: {
                fieldBased: false,
                officeBased: true
            },
            serviceName: "Boru Service",
            serviceStartDate: {
                year: 1995,
                month: 1,
                day: 1
            },
            grade: "A3",
            salaryCode: "C5",
            basicMonthlySalary: 94000
        },
        previousPositions: [],
        previousDuties: [],
        politicallyExposed: false
    };
    string o1id = check post ("/officer", check json.constructFrom (o));
    io:println ("Added officer '" + o.nameWithInitials + "': " + o1id + " to organization '" + i1uuid + "'");
}

function post (string path, json data) returns string|error {
    http:Response hr;
    
    hr = check hc->post (path, data);
    json jr = <@untainted> check hr.getJsonPayload();
    return jr.uuid.toString();
}