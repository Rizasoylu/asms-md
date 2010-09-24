﻿using System.Web;
using MRGSP.ASMS.Core.Model;
using MRGSP.ASMS.Core.Service;
using MRGSP.ASMS.Infra.Dto;
using Omu.ValueInjecter;

namespace MRGSP.ASMS.Infra
{
    public class DossierBuilder : BaseBuilder<Dossier, DossierCreateInput>
    {
        private readonly IUserService userService;

        public DossierBuilder(IUserService userService)
        {
            this.userService = userService;
        }

        protected override DossierCreateInput MakeInput(DossierCreateInput input, Dossier entity)
        {
            input
                .InjectFrom<IdToLookup<Perfecter>>(entity)
                .InjectFrom<IdToLookupMeasure>(entity);
            return input;
        }

        protected override Dossier MakeEntity(Dossier entity, DossierCreateInput input)
        {
            var userName = HttpContext.Current.User.Identity.Name;
            var user = userService.Get(userName);

            entity.InjectFrom<LookupToInt>(input);
            //TODO:entity.ResponsibleId = user.Id;
            return entity;
        }
    }
}