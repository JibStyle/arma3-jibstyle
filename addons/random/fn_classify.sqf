// Classification based on identity token and num classes.
//
// Multiple calls with same args, during same mission, give same result.
//
// Params:
// - token: Number, should be same for calls to be consistent.
// - numClasses: Integer, how many possible cases to choose from.
// Returns: Integer in range [0, numClasses).
params [["_token", 0, [0]], ["_numClasses", 1, [0]]];
floor ((jib_random_seed + _token) random _numClasses);
