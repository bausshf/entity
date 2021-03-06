
module entity.criteria.CriteriaQuery;

import entity;

class CriteriaQuery (T) : CriteriaBase!T {

    this(CriteriaBuilder criteriaBuilder) {
        super(criteriaBuilder);
    }
    public CriteriaQuery!T select(Root!T root) {
        string[] selectColumn = root.getAllSelectColumn();
        foreach(value; root.getJoins()) {
            if (value.joinType == JoinType.INNER) {
                _sqlBuidler.innerJoin(value.tableName, value.joinWhere);
                foreach(v; value.columnNames) {
                    selectColumn ~= v;
                }
            }
            else if (value.joinType == JoinType.LEFT) {
                _sqlBuidler.leftJoin(value.tableName, value.joinWhere);
                foreach(v; value.columnNames) {
                    selectColumn ~= v;
                }
            }
            else {
                _sqlBuidler.rightJoin(value.tableName, value.joinWhere);
                foreach(v; value.columnNames) {
                    selectColumn ~= v;
                }
            } 
        }
        _sqlBuidler.select(selectColumn);
        return this;
    }

    public CriteriaQuery!T select(EntityExpression info) {
        _sqlBuidler.select([info.getSelectColumn()]);
        return this;
    }
    //P = Predicate
    public CriteriaQuery!T where(P...)(P predicates) {
        return cast(CriteriaQuery!T)super.where(predicates);
    }
    //O = Order
    public CriteriaQuery!T orderBy(O...)(O orders) {
        foreach(v; orders) {
            _sqlBuidler.orderBy(v.getColumn(), v.getOrderType());
        }
        return this;
    }
    //E = EntityFieldInfo
    public CriteriaQuery!T groupBy(E...)(E entityFieldInfos) {
        foreach(v; entityFieldInfos) {
            _sqlBuidler.groupBy(v.getFullColumn());
        }
        return this;
    }
    //P = Predicate
    public CriteriaQuery!T having(P...)(P predicates) { 
        string s;
        foreach(k, v; predicates) {
            s ~= v.toString();
            if (k != predicates.length-1) 
                s ~= " AND ";
        }
        _sqlBuidler.having(s);
        return this;
    }
    //E = EntityFieldInfo
    public CriteriaQuery!T multiselect(E...)(E entityExpressions) {
        string[] columns;
        foreach(v; entityExpressions) {
            columns ~= v.getSelectColumn();
        }
        _sqlBuidler.select(columns);
        return this;
    }

    public CriteriaQuery!T distinct(bool distinct) {
        _sqlBuidler.setDistinct(distinct);
        return this;
    }


    public SqlBuilder getSqlBuilder() {return _sqlBuidler;}
    
}
