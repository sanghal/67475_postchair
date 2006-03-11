json.array!(@manager_associations) do |manager_association|
  json.extract! manager_association, :id, :manager_id, :employee_id, :active
  json.url manager_association_url(manager_association, format: :json)
end
