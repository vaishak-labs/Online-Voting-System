<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<nav class="navbar navbar-expand-lg app-header sticky-top py-3">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/">
            <i class="fa-solid fa-check-to-slot fa-lg text-info"></i>
            <span>VoteVault<span class="text-info">.io</span></span>
        </a>
        <button class="navbar-toggler border-0 text-white" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
            <i class="fa-solid fa-bars"></i>
        </button>
        <div class="collapse navbar-collapse" id="navbarContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
                <sec:authorize access="hasRole('ROLE_VOTER')">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/voter/dashboard">
                            <i class="fa-solid fa-gauge me-1"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/voter/elections">
                            <i class="fa-solid fa-box-archive me-1"></i> Elections
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/voter/history">
                            <i class="fa-solid fa-receipt me-1"></i> My Voting Receipt
                        </a>
                    </li>
                </sec:authorize>

                <sec:authorize access="hasRole('ROLE_ADMIN')">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fa-solid fa-chart-line me-1"></i> Admin Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/elections">
                            <i class="fa-solid fa-sliders me-1"></i> Elections
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/candidates">
                            <i class="fa-solid fa-users me-1"></i> Candidates
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/voters">
                            <i class="fa-solid fa-user-shield me-1"></i> Voters Registry
                        </a>
                    </li>
                </sec:authorize>
            </ul>

            <div class="d-flex align-items-center gap-3">
                <sec:authorize access="isAuthenticated()">
                    <div class="text-end text-white-50 small me-2 d-none d-md-block">
                        <div class="text-white fw-bold"><sec:authentication property="name"/></div>
                        <sec:authorize access="hasRole('ROLE_ADMIN')">
                            <span class="badge bg-danger rounded-pill px-2">ADMIN</span>
                        </sec:authorize>
                        <sec:authorize access="hasRole('ROLE_VOTER')">
                            <span class="badge bg-info text-dark rounded-pill px-2">VERIFIED VOTER</span>
                        </sec:authorize>
                    </div>
                    <form action="${pageContext.request.contextPath}/logout" method="post" class="d-inline">
                        <sec:csrfInput/>
                        <button type="submit" class="btn btn-outline-light btn-sm rounded-pill px-3">
                            <i class="fa-solid fa-right-from-bracket me-1"></i> Logout
                        </button>
                    </form>
                </sec:authorize>

                <sec:authorize access="!isAuthenticated()">
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light btn-sm rounded-pill px-3 me-2">Login</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-info btn-sm text-dark fw-bold rounded-pill px-3">Register Voter</a>
                </sec:authorize>
            </div>
        </div>
    </div>
</nav>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const currentPath = window.location.pathname;
        document.querySelectorAll('.navbar-nav .nav-link').forEach(link => {
            const href = link.getAttribute('href');
            if (href && currentPath.startsWith(href) && href !== '${pageContext.request.contextPath}/') {
                link.classList.add('active');
            }
        });
    });
</script>
