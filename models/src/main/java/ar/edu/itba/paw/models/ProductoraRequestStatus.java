package ar.edu.itba.paw.models;

public enum ProductoraRequestStatus {
    PENDING,
    CHANGES_REQUESTED,
    APPROVED,
    REJECTED;

    public static ProductoraRequestStatus fromString(final String raw) {
        if (raw == null) return PENDING;
        try {
            return ProductoraRequestStatus.valueOf(raw);
        } catch (IllegalArgumentException e) {
            return PENDING;
        }
    }

    public boolean isEditable() {
        return this == CHANGES_REQUESTED;
    }

    public boolean isActive() {
        return this == PENDING || this == CHANGES_REQUESTED;
    }
}
