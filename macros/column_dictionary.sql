{% macro column_dictionary(query) %}

{# This macro returns a dictionary of the form {key_to_be_mapped: value_to_be_assigned} #}

    {%- call statement('get_query_results', fetch_result=True,auto_begin=false) -%}

        {{ query }}

    {%- endcall -%}

    {% set sql_results={} %}

    {%- if execute -%}
        {% set sql_results_table = load_result('get_query_results').table.columns %}

        {% if sql_results_table.items() | length >= 2 %}

            {% set key_arr = sql_results_table[0] %}
            {% set val_arr = sql_results_table[1] %}

            {% for i in range(0, key_arr | length) %}
                {% do sql_results.update({key_arr.values()[i]: val_arr.values()[i]}) %}
            {% endfor %}
        
        {% endif %}

    {%- endif -%}

    {{ return(sql_results) | length }}

{% endmacro %}