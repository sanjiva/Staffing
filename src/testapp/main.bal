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
        idNumber: "201000151616x",
        nameWithInitials: "John Smith",
        dob: {
            year: 2001,
            month: 12,
            day: 31
        },
        gender: <Gender> "M",
        address: { 
            line1: "1 Serious Road",
            line2: "මඩකලපුව"
        },
        mobilePhone: "077-888-6631",
        homePhone: "018-888-1361",
        email: "john@mada.lk",
        emergencyContact: {
            name: "Daddy be There",
            phone: "011-888-6141"
        },
        pollingStationId: "BB-987",
        preferredDistrictIds: ["Batticoloar", "Colombo", "Chilaw", "Jaffna", "Gampaha"],
        position: {
            instituteUuid: i1uuid,
            post: "Nikang Boss",
            postNature: {
                fieldBased: false,
                officeBased: true
            },
            serviceName: "Maara Service",
            serviceStartDate: {
                year: 1995,
                month: 1,
                day: 1
            },
            grade: "A3",
            salaryCode: "C15",
            basicMonthlySalary: 49411
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