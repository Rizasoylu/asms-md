﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Index
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<%
    var c = ViewContext.RouteData.Values["Controller"].ToString();
    var h = 250;
    %>
<% Html.RenderPartial("header");%>

    <%=Html.Confirm("Are you sure you want to delete this " + c + " ?") %>
    <%=Html.MakePopupForm("create", title:"create "+c,  successFunction:"create", height:h) %>
    <%=Html.MakePopupForm("Edit", new[]{"id"}, title:"edit " + c, successFunction:"edit", height:h) %>    
    
    <script type="text/javascript">
        var page = 1;
        function addStart(d) { $(d).css('opacity', 0).prependTo("#list").animate({ opacity: 1 }, 600, 'easeInCubic'); }
        function addEnd(d) { $(d).css('opacity', 0).appendTo("#list").animate({ opacity: 1 }, 300, 'easeInCubic'); }

        function create(o) { $.get('<%=Url.Action("row") %>', { id: o.Id }, function (d) { addStart(d);}); }
        function edit(o) {$.get('<%=Url.Action("row") %>', { id: o.Id }, function (d) { $("#o" + o.Id).before(d).remove(); $("#o" + o.Id).hide().fadeIn('slow'); });}
        var lfm;
        $(function () {
            regForm();
            $(this).ajaxComplete(regForm);
            $('#more').click(more);
            $('#sform').ajaxForm({ success: function (d) {
                $("#list").html(d.rows);
                page = 1;
                if (d.more) $('#more').show(); else $('#more').hide();
                lfm = $('#sform').formSerialize();
            }
            }).submit();
        });        

        function regForm() {
            $(".fconfirm").ajaxForm({ success: function (d) { $('#o' + d.Id).fadeOut('slow', function () { $(this).remove(); styleup(); }); } });
        }

        function more() {
            page++;
            $.post('<%=Url.Action("search") %>', lfm + '&page=' + page, function (d) {
            addEnd(d.rows);
            if (d.more) $('#more').show(); else $('#more').fadeOut('slow');                           
            });
        }        
    </script>

    <form id="sform" action="<%=Url.Action("search") %>" method="post">
    <% Html.RenderPartial("searchbox"); %>    
    </form>
    <br />
    <%=Html.PopupFormActionLink("create","creaza", htmlAttributes: new{@class="abtn"}) %>
    <br />
    <br />
    <table class="atbl">
        <thead>
            <%Html.RenderPartial("hrow"); %>
        </thead>
        <tbody id="list">
        </tbody>
    </table>   
    <br />
    <a id="more" class="abtn" >mai mult...</a>
</asp:Content>
