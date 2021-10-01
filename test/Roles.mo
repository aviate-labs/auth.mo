import Principal "mo:base/Principal";

import Roles "../src/Roles";

let p = Principal.fromText("aaaaa-aa");
let a1 = Principal.fromText("rkp4c-7iaaa-aaaaa-aaaca-cai");
let a2 = Principal.fromText("rrkah-fqaaa-aaaaa-aaaaq-cai");

let users = Roles.Users([(p, [Roles.ALL])]);
assert(Roles.toStable(p, users) == [
    (p, [Roles.ALL]),
]);

users.addUserWithRoles(p, a1, [Roles.USERS_ADD, Roles.USERS_GET]);
assert(Roles.toStable(a1, users) == [
    (p,  [Roles.ALL]),
    (a1, [Roles.USERS_ADD, Roles.USERS_GET])
]);

let CUSTOM_ROLE : Roles.Role = "custom";
users.addUserWithRoles(a1, a2, [CUSTOM_ROLE]);
assert(users.hasRole(a2, CUSTOM_ROLE));
assert(Roles.toStable(a1, users) == [
    (p,  [Roles.ALL]),
    (a1, [Roles.USERS_ADD, Roles.USERS_GET]),
    (a2, [CUSTOM_ROLE]),
]);
assert(Roles.toStable(a2, users) == []);

// Can not remove other users.
users.removeUser(a2, a1);
assert(Roles.toStable(a1, users).size() == 3);

func hasCustomRole(user : Principal) : Bool {
    users.hasRole(user, CUSTOM_ROLE);
};

assert(hasCustomRole(p));
assert(not hasCustomRole(a1));
assert(hasCustomRole(a2));
