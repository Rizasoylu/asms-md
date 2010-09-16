﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<FieldInput>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Create
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Creaza camp</h2>
    <% using (Html.BeginForm())
       {%>
    <%: Html.ValidationSummary(true) %>

        <%=Html.EditorFor(o => o.Name) %>
        <%=Html.EditorFor(o => o.Description) %>        
        <% Html.RenderPartial("save"); %>

    <% } %>
    <%=Html.ClientSideValidation<FieldInput>() %>
    <div>
        <%: Html.ActionLink("Inapoi", "Index") %>
    </div>
</asp:Content>
