-- WITH source AS (
--    SELECT
      --  alias_name,
      --   created_at,
      --   created_by_admin_user_id,
      --   created_by_user_id,
      --   deleted_at,
      --   hq_flag,
      --   hq_id,
      --   id,
      --   managed_by_id,
      --   name,
      --   non_participating,
      --   subdomain,
      --   cast(tenant_types as text) as tenant_types,
      --   test_tenant,
      --   updated_at
   -- FROM public.monolith_tenants
-- )

-- select * from source
{{ config(materialized='incremental', unique_key='id') }}

WITH source AS (
    SELECT
        alias_name,
        created_at,
        created_by_admin_user_id,
        created_by_user_id,
        deleted_at,
        hq_flag,
        hq_id,
        id,
        managed_by_id,
        name,
        non_participating,
        subdomain,
        cast(tenant_types as text) as tenant_types,
        test_tenant,
        updated_at
    FROM {{ source('my_source', 'monolith_tenants') }}
)

select * from source

{% if is_incremental() %}
  WHERE updated_at > (SELECT max(updated_at) FROM {{ this }})
{% endif %}
