import Archivable

extension Cloud where A == Archive {
    public static var new: Self {
        let cloud = Self()
        Task {
            await cloud.load(container: .init(name: "iCloud.shortbread"))
        }
        return cloud
    }
    
    public func new(secret: String) async -> Int {
        arch
            .secrets
            .append(
                .new
                    .with(payload: secret))
        await stream()
        return arch.secrets.count - 1
    }
    
    public func delete(index: Int) async {
        arch
            .secrets
            .remove(at: index)
        await stream()
    }
    
    public func update(index: Int, name: String) async {
        arch
            .secrets
            .mutate(index: index) {
                $0.with(name: name)
            }
        await stream()
    }
    
    public func update(index: Int, payload: String) async {
        arch
            .secrets
            .mutate(index: index) {
                $0.with(payload: payload)
            }
        await stream()
    }
    
    public func update(index: Int, favourite: Bool) async {
        arch
            .secrets
            .mutate(index: index) {
                $0.with(favourite: favourite)
            }
        await stream()
    }
    
    public func add(index: Int, tag: Tag) async {
        arch
            .secrets
            .mutate(index: index) {
                $0.with(tags: $0
                            .tags
                            .inserting(tag))
            }
        await stream()
    }
    
    public func remove(index: Int, tag: Tag) async {
        arch
            .secrets
            .mutate(index: index) {
                $0.with(tags: $0
                            .tags
                            .removing(tag))
            }
        await stream()
    }
}
