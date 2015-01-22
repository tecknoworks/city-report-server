require 'spec_helper'

describe 'API' do
  def check_route(a, b)
    a.should route_to(b)
  end

  it 'routes' do
    check_route({ post: '/images'}, { controller: 'images', action: 'create' })

    check_route({ get: '/issues'}, { controller: 'issues', action: 'index' })
    check_route({ get: '/issues/1'}, { controller: 'issues', action: 'show', id: '1' })
    check_route({ post: '/issues'}, { controller: 'issues', action: 'create' })
    check_route({ put: '/issues/1'}, { controller: 'issues', action: 'update', id: '1' })
    check_route({ patch: '/issues/1'}, { controller: 'issues', action: 'update', id: '1' })
    check_route({ put: '/issues/1/add_to_set'}, { controller: 'issues', action: 'add_to_set', id: '1' })
    check_route({ patch: '/issues/1/add_to_set'}, { controller: 'issues', action: 'add_to_set', id: '1' })
    check_route({ post: '/issues/1/vote'}, { controller: 'issues', action: 'vote', id: '1' })

    check_route({ get: '/meta'}, { controller: 'web', action: 'meta' })
    check_route({ get: '/about'}, { controller: 'web', action: 'about' })
    check_route({ get: '/eula'}, { controller: 'web', action: 'eula' })
  end
  
  # rails routing from the outside in
  it 'routes the internship' do
    check_route({ get: '/internship' }, { controller: 'web', action: 'internship_show' }) 
    check_route({ post: '/internship' }, { controller: 'web', action: 'internship_create' })
    check_route({ patch: '/internship/1' }, { controller: 'web', action: 'internship_update', id: '1' })
    check_route({ delete: '/internship/1' }, { controller: 'web', action: 'internship_delete', id: '1' })
  end
end
