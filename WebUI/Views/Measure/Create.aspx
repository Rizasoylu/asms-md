﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<MeasureInput>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Create
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Creaza masura</h2>
    <% using (Html.BeginForm())
       {%>
    <%: Html.ValidationSummary(true) %>
    <%=Html.Input(o => o.Name) %>
    <%=Html.Input(o => o.Description) %>
    <%=Html.Input(o => o.NoContest) %>
    <% Html.RenderPartial("save"); %>
    <% } %>
    <%=Html.ClientSideValidation<FieldInput>() %>
    <div>
        <%: Html.ActionLink("Inapoi", "Index") %>
    </div>
</asp:Content>
