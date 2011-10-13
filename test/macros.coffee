assert = require 'assert'

# A macro for building up sql tests. Each sub-context will clone the query
exports.newQuery = (subctx) ->
	sql = subctx.sql
	mod = subctx.mod
	msg = subctx.msg || "SQL is correct \"#{sql}\""
	par = subctx.par
	delete subctx.sql
	delete subctx.mod
	delete subctx.msg
	delete subctx.par

	subctx.topic ?= if mod.length == 0
		(q) -> q.clone().visit mod
	else
		(q) -> mod q.clone()
	if sql?
		subctx[msg] = (q) -> assert.equal q.toSql(), sql
	if par?
		subctx["Parameters correct: #{par}"] = (q) ->
			assert.deepEqual(q.s.parameters, par)
	subctx
