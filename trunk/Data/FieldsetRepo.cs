﻿using MRGSP.ASMS.Core.Model;
using MRGSP.ASMS.Core.Repository;

namespace MRGSP.ASMS.Data
{
    public class FieldsetRepo : Repo<Fieldset>, IFieldsetRepo
    {
        public FieldsetRepo(IConnectionFactory connFactory)
            : base(connFactory)
        {
        }

        public int ChangeState(int id, int stateId)
        {
            return DbUtil.ExecuteNonQuerySp("changeFieldsetState", Cs, new { id, stateId });
        }

        public int Activate(int id)
        {
            return DbUtil.ExecuteNonQuerySp("activateFieldset", Cs, new { id });
        }

    }
}