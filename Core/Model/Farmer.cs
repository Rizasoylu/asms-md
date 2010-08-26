﻿using System;

namespace MRGSP.ASMS.Core.Model
{
    public class Farmer : Entity
    {
        public FarmerType FType { get; set; }
    }

    public class FarmerInfo : EntityWithName
    {
        public string FiscalCode { get; set; }
        public FarmerType FType { get; set; }
    }

    public class FarmerVersionInfo : EntityWithName
    {
        public int FarmerId { get; set; }
        public string FiscalCode { get; set; }
        public FarmerType FType { get; set; }
    }

    public abstract class FarmersEntity : Entity
    {
        public int FarmerId { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime? EndDate { get; set; }
    }

    public class FarmerVersion : Entity
    {
        public int FarmerId { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime? EndDate { get; set; }
    }

    public class LandOwner : Entity
    {
        public int FarmerVersionId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string FathersName { get; set; }
        public DateTime DateOfBirth { get; set; }
        public string FiscalCode { get; set; }
    }

    public class LandOwnerInfo : LandOwner
    {
        public DateTime StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int FarmerId { get; set; }
    }

    public class Organization : Entity
    {
        public int FarmerVersionId { get; set; }
        public string Name { get; set; }
        public string FiscalCode { get; set; }
        public int OrganizationFormId { get; set; }
        public DateTime RegDate { get; set; }
        public string RegNr { get; set; }
        public string ActivityType { get; set; }
    }

    public class OrganizationInfo : Organization
    {
        public string OrganizationForm { get; set; }
        public int FarmerId { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime? EndDate { get; set; }
    }

    public class Address : FarmersEntity
    {
        public int DistrictId { get; set; }
        public string Locality { get; set; }
        public string Zip { get; set; }
        public string Street { get; set; }
        public string House { get; set; }
        public string Apartment { get; set; }
    }

    public class AddressInfo : Address
    {
        public string District { get; set; }
    }

    public class Phone : FarmersEntity
    {
        public string Number { get; set; }
        public PhoneType Type { get; set; }
    }

    public class Email : FarmersEntity
    {
        public string Address { get; set; }
    }


}