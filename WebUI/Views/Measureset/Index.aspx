﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IPageable<MeasuresetDisplay>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Index
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Seturi de masuri</h2>
        <% Html.RenderPartial("bcreate"); %>
    <table>
        <thead>
            <tr>
                <td>
                    nume
                </td>
                <td>
                    data sfarsit
                </td><td>
                    stare
                </td><td></td>
            </tr>
        </thead>
        <% foreach (var o in Model.Page)
           {%>
        <tr>
            <td>
                <%:o.Name %>
            </td>
            <td>
                <%:o.EndDate.ToShortDateString() %>
            </td><td>
                <%:o.State%>
            </td><td>
                <%:Html.ActionLink("deschide", "open", new{o.Id}, null)%>
                <%:Html.ActionLink("vizualizeaza", "view", new{o.Id}, null)%>
            </td>
        </tr>
        <%
            }%>
    </table>
    <%=Html.Pagination() %>
</asp:Content>
