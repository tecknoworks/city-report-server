json.version '1.0.0'
json.statuses Issue::VALID_STATUSES
json.categories Category.to_api
json.zones Zone.to_api
json.error_codes RequestCodes.constants.collect{|cst| [RequestCodes.const_get(cst), cst] }.to_h
