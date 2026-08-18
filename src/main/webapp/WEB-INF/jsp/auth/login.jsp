<c:set var="pageTitle" value="Login - Secure Online Voting System" />
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="auth-wrapper">
    <div class="auth-card">
        <div class="text-center mb-4">
            <div class="d-inline-flex align-items-center justify-content-center bg-primary bg-opacity-10 text-primary rounded-circle p-3 mb-3">
                <i class="fa-solid fa-user-lock fa-2x"></i>
            </div>
            <h3 class="fw-bold text-dark mb-1">Voter & Admin Login</h3>
            <p class="text-muted small">Sign in using your Email Address or Voter ID</p>
        </div>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 small" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-1"></i> Invalid credentials or unverified voter status. Please check your credentials and try again.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty param.logout}">
            <div class="alert alert-info alert-dismissible fade show rounded-3 small" role="alert">
                <i class="fa-solid fa-circle-check me-1"></i> You have been successfully logged out of the voting portal.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 small" role="alert">
                <i class="fa-solid fa-circle-check me-1"></i> ${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <sec:csrfInput/>
            <div class="mb-3">
                <label for="username" class="form-label fw-semibold small text-secondary">Email or Voter ID</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0 text-muted"><i class="fa-solid fa-id-card"></i></span>
                    <input type="text" class="form-control bg-light border-start-0 ps-0" id="username" name="username" placeholder="e.g. voter1@voting.com or VOT-10001" required autofocus>
                </div>
            </div>

            <div class="mb-4">
                <div class="d-flex justify-content-between align-items-center mb-1">
                    <label for="password" class="form-label fw-semibold small text-secondary">Password</label>
                </div>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0 text-muted"><i class="fa-solid fa-lock"></i></span>
                    <input type="password" class="form-control bg-light border-start-0 ps-0" id="password" name="password" placeholder="••••••••" required>
                </div>
            </div>

            <button type="submit" class="btn btn-primary-custom w-100 mb-3 py-2">
                <i class="fa-solid fa-right-to-bracket me-2"></i> Access Voting Booth
            </button>

            <div class="text-center">
                <p class="small text-muted mb-0">New Voter? <a href="${pageContext.request.contextPath}/register" class="text-primary fw-semibold text-decoration-none">Register for Voter ID</a></p>
            </div>
        </form>

        <hr class="my-4 text-muted opacity-25">
        <div class="bg-light p-3 rounded-3 border">
            <div class="fw-bold small text-dark mb-1"><i class="fa-solid fa-key text-warning me-1"></i> Quick Demo Logins:</div>
            <div class="small text-muted"><strong>Admin:</strong> <code>admin@voting.com</code> / <code>admin123</code></div>
            <div class="small text-muted"><strong>Voter:</strong> <code>voter1@voting.com</code> / <code>voter123</code></div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
