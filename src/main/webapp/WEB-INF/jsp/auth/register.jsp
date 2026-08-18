<c:set var="pageTitle" value="Voter Registration - Online Voting System" />
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="auth-wrapper">
    <div class="auth-card" style="max-width: 540px;">
        <div class="text-center mb-4">
            <div class="d-inline-flex align-items-center justify-content-center bg-info bg-opacity-10 text-info rounded-circle p-3 mb-3">
                <i class="fa-solid fa-address-card fa-2x"></i>
            </div>
            <h3 class="fw-bold text-dark mb-1">Voter Registration</h3>
            <p class="text-muted small">Register your official account to receive a unique digital Voter ID</p>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 small" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-1"></i> ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post">
            <sec:csrfInput/>
            <div class="mb-3">
                <label for="fullName" class="form-label fw-semibold small text-secondary">Full Name</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0 text-muted"><i class="fa-solid fa-user"></i></span>
                    <input type="text" class="form-control bg-light border-start-0 ps-0" id="fullName" name="fullName" value="${registrationDto.fullName}" placeholder="e.g. John Doe" required>
                </div>
            </div>

            <div class="mb-3">
                <label for="email" class="form-label fw-semibold small text-secondary">Email Address</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0 text-muted"><i class="fa-solid fa-envelope"></i></span>
                    <input type="email" class="form-control bg-light border-start-0 ps-0" id="email" name="email" value="${registrationDto.email}" placeholder="voter@example.com" required>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="password" class="form-label fw-semibold small text-secondary">Password</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0 text-muted"><i class="fa-solid fa-lock"></i></span>
                        <input type="password" class="form-control bg-light border-start-0 ps-0" id="password" name="password" placeholder="Min 6 characters" required>
                    </div>
                </div>
                <div class="col-md-6 mb-4">
                    <label for="confirmPassword" class="form-label fw-semibold small text-secondary">Confirm Password</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0 text-muted"><i class="fa-solid fa-shield-check"></i></span>
                        <input type="password" class="form-control bg-light border-start-0 ps-0" id="confirmPassword" name="confirmPassword" placeholder="Confirm password" required>
                    </div>
                </div>
            </div>

            <div class="form-check mb-4 small">
                <input class="form-check-input" type="checkbox" id="terms" required checked>
                <label class="form-check-label text-muted" for="terms">
                    I verify that I am an eligible voter and agree to the election terms of service.
                </label>
            </div>

            <button type="submit" class="btn btn-primary-custom w-100 mb-3 py-2">
                <i class="fa-solid fa-user-plus me-2"></i> Register & Issue Voter ID
            </button>

            <div class="text-center">
                <p class="small text-muted mb-0">Already registered? <a href="${pageContext.request.contextPath}/login" class="text-primary fw-semibold text-decoration-none">Sign In Here</a></p>
            </div>
        </form>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
