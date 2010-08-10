﻿using System;
using System.Collections.Generic;
using System.Linq;
using MRGSP.ASMS.Core;
using MRGSP.ASMS.Core.Model;
using MRGSP.ASMS.Core.Repository;
using MRGSP.ASMS.Core.Service;
using Omu.ValueInjecter;

namespace MRGSP.ASMS.Service
{
    public class MeasuresetService : IMeasuresetService
    {
        private readonly IMeasureRepo mRepo;
        private readonly IRepo<State> sRepo;
        private readonly IMeasuresetRepo msRepo;

        public MeasuresetService(IMeasureRepo mRepo, IMeasuresetRepo msRepo, IRepo<State> sRepo)
        {
            this.mRepo = mRepo;
            this.sRepo = sRepo;
            this.msRepo = msRepo;
        }

        public Measureset Get(int id)
        {
            return msRepo.Get(id);
        }

        public void Activate(int id)
        {
            Do(() => msRepo.Activate(id), States.Registered, id);
        }

        public void Deactivate(int id)
        {
            Do(() => msRepo.ChangeState(id, (int)States.Inactive), States.Active, id);
        }

        public IEnumerable<Measure> GetAssignedMeasures(int measuresetId)
        {
            return mRepo.GetAssigned(measuresetId);
        }

        public IEnumerable<Measure> GetUnassignedMeasures(int measuresetId)
        {
            return mRepo.GetUnassigned(measuresetId);
        }

        public void Assign(int measureId, int measuresetId)
        {
            Do(() => mRepo.Assign(measureId, measuresetId), States.Registered, measuresetId);
        }

        public void Unassign(int measureId, int measuresetId)
        {
            Do(() => mRepo.Unassign(measureId, measuresetId), States.Registered, measuresetId);
        }

        private void Do(Action a, States state, int measuresetId)
        {
            var ms = msRepo.Get(measuresetId);

            if (state.IsEqual(ms.StateId))
                a();
            else
                throw new AsmsEx("Invalid operation");
        }

        public IPageable<MeasuresetDisplay> GetPageable(int page, int pageSize)
        {
            var ms = msRepo.GetPageable(page, pageSize);
            var ss = sRepo.GetAll();
            var d = new Pageable<MeasuresetDisplay>();
            d.InjectFrom(ms);
            d.Page = ms.Page.Join(ss, o => o.StateId, oo => oo.Id,
                                  (o, oo) =>
                                  new MeasuresetDisplay { Id = o.Id, Year = o.Year, Name = o.Name, State = oo.Name });
            return d;
        }

        public Measureset GetActive()
        {
            return msRepo.GetWhere(new {stateId = (int)States.Active}).FirstOrDefault();
        }
    }
}