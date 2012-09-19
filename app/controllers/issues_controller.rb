class IssuesController < ApplicationController
  api :GET, "/issues", "Show all issues"
  description "returns a JSON containing all the issues available"
  formats ['json']
  example "{
    'status':{
      'code':200,
      'message':'Success'
    },
    'response': {
      'issues':[
        {issue1},
        {issue2},
        ...
        ]
    }
}"
  def index
    issues = Issue.all
    respond_to do |format|
      format.json { render :json => render_response(ApiStatus.OK_CODE, ApiStatus.OK, {issues:issues}) }
    end
  end

end
