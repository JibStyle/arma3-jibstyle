// Continuous random calculation based on identity token.
//
// Multiple calls with same args, during same mission, give same result.
//
// Params:
// - token: Number, should be same for calls to be consistent.
// Returns: Number in range [0, 1).
params [["_token", 0, [0]]];
(jib_random_seed + _token) random 1;
